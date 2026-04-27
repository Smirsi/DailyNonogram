import SwiftUI
import Combine

// MARK: - Supporting Types

struct GridCoord: Hashable {
    let row: Int
    let col: Int
}

struct CellChange {
    let row: Int
    let col: Int
    let from: CellState
    let to: CellState
}

// MARK: - ViewModel

@MainActor
class NonogramViewModel: ObservableObject {
    let nonogram: Nonogram

    @Published var grid: [[CellState]]
    @Published var currentTool: Tool = .pen
    @Published var showCompletion: Bool = false
    @Published var isWronglyComplete: Bool = false
    @Published var checkedRowClues: [[Bool]] = []
    @Published var checkedColClues: [[Bool]] = []

    /// True when auto-solve was used — disables hints for this puzzle.
    @Published private(set) var hintsBlocked = false
    /// Remaining hints for this puzzle (2 for free, 5 for premium).
    @Published private(set) var hintsRemaining: Int = 2
    /// Whether there are moves to undo.
    @Published private(set) var canUndo = false
    /// Whether there are moves to redo.
    @Published private(set) var canRedo = false

    @AppStorage("autoX") private var autoX = false
    @AppStorage("autoCheckmark") private var autoCheckmark = false

    private var undoStack: [[CellChange]] = []
    private var redoStack: [[CellChange]] = []
    private var gridSnapshotBeforeDrag: [[CellState]]? = nil
    private var dragTargetState: CellState = .filled
    private var visitedInDrag: Set<GridCoord> = []
    private var didLockPuzzle = false

    init(nonogram: Nonogram, savedGrid: [[CellState]]? = nil) {
        self.nonogram = nonogram
        self.grid = savedGrid ?? Array(
            repeating: Array(repeating: .empty, count: nonogram.cols),
            count: nonogram.rows
        )
        let emptyRowChecks = nonogram.rowClues.map { Array(repeating: false, count: $0.count) }
        let emptyColChecks = nonogram.colClues.map { Array(repeating: false, count: $0.count) }
        self.checkedRowClues = emptyRowChecks
        self.checkedColClues = emptyColChecks
        if savedGrid != nil {
            updateAutoFeatures()
        }
    }

    // MARK: - Completion Check

    var isComplete: Bool {
        for row in 0..<nonogram.rows {
            for col in 0..<nonogram.cols {
                let shouldBeFilled = nonogram.solution[row][col]
                let state = grid[row][col]
                let isFilled = state == .filled || state == .hinted
                if shouldBeFilled != isFilled { return false }
            }
        }
        return true
    }

    // MARK: - Drag & Tap

    func beginDrag(at coord: GridCoord) {
        lockIfNeeded()
        if gridSnapshotBeforeDrag == nil {
            gridSnapshotBeforeDrag = grid
        }
        visitedInDrag = []
        dragTargetState = targetState(for: coord)
        applyCell(targetState: dragTargetState, at: coord)
    }

    func continueDrag(at coord: GridCoord) {
        guard !visitedInDrag.contains(coord) else { return }
        applyCell(targetState: dragTargetState, at: coord)
    }

    func endDrag() {
        visitedInDrag = []
        updateAutoFeatures()
        if let snapshot = gridSnapshotBeforeDrag {
            recordUndo(from: snapshot)
            gridSnapshotBeforeDrag = nil
        }
        saveAndCheckCompletion()
    }

    func handleTap(at coord: GridCoord) {
        lockIfNeeded()
        let snapshot = grid
        let target = targetState(for: coord)
        applyCell(targetState: target, at: coord)
        updateAutoFeatures()
        recordUndo(from: snapshot)
        saveAndCheckCompletion()
    }

    // MARK: - Undo / Redo

    func undo() {
        guard let changes = undoStack.popLast() else { return }
        for c in changes { grid[c.row][c.col] = c.from }
        redoStack.append(changes)
        updateUndoRedoState()
        if autoCheckmark { updateCheckedClues() } else { resetCheckedClues() }
        DailyPuzzleService.saveProgress(grid, difficulty: nonogram.difficulty)
    }

    func redo() {
        guard let changes = redoStack.popLast() else { return }
        for c in changes { grid[c.row][c.col] = c.to }
        undoStack.append(changes)
        updateUndoRedoState()
        if autoCheckmark { updateCheckedClues() } else { resetCheckedClues() }
        DailyPuzzleService.saveProgress(grid, difficulty: nonogram.difficulty)
    }

    // MARK: - Hint

    /// Sets hint allowance for this puzzle. Call on puzzle load.
    func resetHints(isPremium: Bool) {
        hintsRemaining = isPremium ? 5 : 2
    }

    /// Refills hints (called after rewarded ad watched when hintsRemaining == 0).
    func refillHints(isPremium: Bool) {
        hintsRemaining = isPremium ? 5 : 2
    }

    /// Reveals one random correct-but-unfilled cell. Call only after rewarded ad confirmed.
    func applyHint() {
        guard !hintsBlocked, hintsRemaining > 0 else { return }
        hintsRemaining -= 1
        let candidates = (0..<nonogram.rows).flatMap { row in
            (0..<nonogram.cols).compactMap { col -> GridCoord? in
                guard nonogram.solution[row][col] else { return nil }
                let s = grid[row][col]
                guard s != .filled && s != .hinted else { return nil }
                return GridCoord(row: row, col: col)
            }
        }
        guard let coord = candidates.randomElement() else { return }
        let snapshot = grid
        grid[coord.row][coord.col] = .hinted
        updateAutoFeatures()
        recordUndo(from: snapshot)
        saveAndCheckCompletion()
    }

    // MARK: - Error Reveal (Premium)

    /// Marks up to `count` wrongly-filled cells as `.error`. Call only after rewarded ad confirmed.
    func applyErrors(max count: Int = 5) {
        let wrong = (0..<nonogram.rows).flatMap { row in
            (0..<nonogram.cols).compactMap { col -> GridCoord? in
                guard grid[row][col] == .filled, !nonogram.solution[row][col] else { return nil }
                return GridCoord(row: row, col: col)
            }
        }
        let toReveal = Array(wrong.shuffled().prefix(count))
        guard !toReveal.isEmpty else { return }
        let snapshot = grid
        for coord in toReveal { grid[coord.row][coord.col] = .error }
        recordUndo(from: snapshot)
        DailyPuzzleService.saveProgress(grid, difficulty: nonogram.difficulty)
    }

    // MARK: - Auto-Solve (Premium)

    /// Fills the entire puzzle with the correct solution. Blocks hints afterwards.
    func applySolve() {
        let snapshot = grid
        for row in 0..<nonogram.rows {
            for col in 0..<nonogram.cols {
                grid[row][col] = nonogram.solution[row][col] ? .filled : .autoCrossed
            }
        }
        hintsBlocked = true
        updateCheckedClues()
        recordUndo(from: snapshot)
        DailyPuzzleService.saveProgress(grid, difficulty: nonogram.difficulty)
        DailyPuzzleService.markSolved(difficulty: nonogram.difficulty)
        showCompletion = true
    }

    // MARK: - Auto Features (FUN1.12)

    private func updateAutoFeatures() {
        if autoX { applyAutoX() }
        if autoCheckmark { updateCheckedClues() } else { resetCheckedClues() }
    }

    private func resetCheckedClues() {
        checkedRowClues = nonogram.rowClues.map { Array(repeating: false, count: $0.count) }
        checkedColClues = nonogram.colClues.map { Array(repeating: false, count: $0.count) }
    }

    /// Improved autoX: uses block-sequence comparison instead of sum-only comparison.
    private func applyAutoX() {
        for row in 0..<nonogram.rows {
            guard rowLineIsComplete(row) else { continue }
            for col in 0..<nonogram.cols where grid[row][col] == .empty {
                grid[row][col] = .autoCrossed
            }
        }
        for col in 0..<nonogram.cols {
            guard colLineIsComplete(col) else { continue }
            for row in 0..<nonogram.rows where grid[row][col] == .empty {
                grid[row][col] = .autoCrossed
            }
        }
    }

    private func rowLineIsComplete(_ row: Int) -> Bool {
        let cells = grid[row].map { $0 == .filled || $0 == .hinted }
        return lineMatchesClues(cells: cells, clues: nonogram.rowClues[row])
    }

    private func colLineIsComplete(_ col: Int) -> Bool {
        let cells = (0..<nonogram.rows).map { grid[$0][col] == .filled || grid[$0][col] == .hinted }
        return lineMatchesClues(cells: cells, clues: nonogram.colClues[col])
    }

    private func lineMatchesClues(cells: [Bool], clues: [Int]) -> Bool {
        let sequences = filledSequences(in: cells)
        if clues == [0] { return sequences.isEmpty }
        return sequences == clues
    }

    private func updateCheckedClues() {
        checkedRowClues = (0..<nonogram.rows).map { row in
            let cells = grid[row].map { $0 == .filled || $0 == .hinted }
            return matchClues(nonogram.rowClues[row], toCells: cells)
        }
        checkedColClues = (0..<nonogram.cols).map { col in
            let cells = (0..<nonogram.rows).map { grid[$0][col] == .filled || grid[$0][col] == .hinted }
            return matchClues(nonogram.colClues[col], toCells: cells)
        }
    }

    private func filledSequences(in cells: [Bool]) -> [Int] {
        var result: [Int] = []
        var count = 0
        for cell in cells {
            if cell { count += 1 }
            else if count > 0 { result.append(count); count = 0 }
        }
        if count > 0 { result.append(count) }
        return result
    }

    // Matches clues against the current cell state, supporting partial
    // strikethrough from both ends for confirmed (sealed) blocks.
    private func matchClues(_ clues: [Int], toCells cells: [Bool]) -> [Bool] {
        guard clues != [0] else { return [cells.allSatisfy { !$0 }] }

        // Extract blocks with start positions
        var blocks: [(start: Int, length: Int)] = []
        var i = 0
        while i < cells.count {
            if cells[i] {
                let start = i
                while i < cells.count && cells[i] { i += 1 }
                blocks.append((start: start, length: i - start))
            } else {
                i += 1
            }
        }

        // Full exact match
        if blocks.map(\.length) == clues {
            return Array(repeating: true, count: clues.count)
        }

        var result = Array(repeating: false, count: clues.count)

        // From left: mark consecutive clues whose sealed blocks match
        var leftClueIdx = 0
        var leftBlockIdx = 0
        while leftBlockIdx < blocks.count && leftClueIdx < clues.count {
            let block = blocks[leftBlockIdx]
            let afterEnd = block.start + block.length
            let sealedRight = afterEnd >= cells.count || !cells[afterEnd]
            if block.length == clues[leftClueIdx] && sealedRight {
                result[leftClueIdx] = true
                leftClueIdx += 1
                leftBlockIdx += 1
            } else {
                break
            }
        }

        // From right: mark consecutive clues whose sealed blocks match (no overlap with left)
        var rightClueIdx = clues.count - 1
        var rightBlockIdx = blocks.count - 1
        while rightBlockIdx >= leftBlockIdx && rightClueIdx >= leftClueIdx {
            let block = blocks[rightBlockIdx]
            let sealedLeft = block.start == 0 || !cells[block.start - 1]
            if block.length == clues[rightClueIdx] && sealedLeft {
                result[rightClueIdx] = true
                rightClueIdx -= 1
                rightBlockIdx -= 1
            } else {
                break
            }
        }

        return result
    }

    // MARK: - Private Helpers

    private func targetState(for coord: GridCoord) -> CellState {
        let current = grid[coord.row][coord.col]
        switch currentTool {
        case .pen:
            switch current {
            case .filled, .error: return .empty
            case .hinted: return .hinted
            default: return .filled
            }
        case .eraser:
            return current == .hinted ? .hinted : .empty
        case .marker:
            return current == .crossed ? .empty : .crossed
        }
    }

    private func applyCell(targetState: CellState, at coord: GridCoord) {
        guard coord.row >= 0, coord.row < nonogram.rows,
              coord.col >= 0, coord.col < nonogram.cols else { return }
        visitedInDrag.insert(coord)
        grid[coord.row][coord.col] = targetState
    }

    private func lockIfNeeded() {
        guard !didLockPuzzle else { return }
        didLockPuzzle = true
        PuzzleLockService.lockPuzzle(difficulty: nonogram.difficulty)
    }

    private func saveAndCheckCompletion() {
        DailyPuzzleService.saveProgress(grid, difficulty: nonogram.difficulty)
        if isComplete {
            isWronglyComplete = false
            DailyPuzzleService.markSolved(difficulty: nonogram.difficulty)
            showCompletion = true
        } else {
            var solutionCount = 0
            var filledCount = 0
            for row in 0..<nonogram.rows {
                for col in 0..<nonogram.cols {
                    if nonogram.solution[row][col] { solutionCount += 1 }
                    let s = grid[row][col]
                    if s == .filled || s == .hinted { filledCount += 1 }
                }
            }
            isWronglyComplete = (solutionCount > 0 && filledCount == solutionCount)
        }
    }

    private func recordUndo(from snapshot: [[CellState]]) {
        var changes: [CellChange] = []
        for row in 0..<nonogram.rows {
            for col in 0..<nonogram.cols {
                let old = snapshot[row][col]
                let new = grid[row][col]
                if old != new { changes.append(CellChange(row: row, col: col, from: old, to: new)) }
            }
        }
        guard !changes.isEmpty else { return }
        undoStack.append(changes)
        redoStack.removeAll()
        updateUndoRedoState()
    }

    private func updateUndoRedoState() {
        canUndo = !undoStack.isEmpty
        canRedo = !redoStack.isEmpty
    }
}
