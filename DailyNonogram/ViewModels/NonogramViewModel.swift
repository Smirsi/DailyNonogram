import SwiftUI
import Combine

@MainActor
class NonogramViewModel: ObservableObject {
    let nonogram: Nonogram

    @Published var grid: [[CellState]]
    @Published var currentTool: Tool = .pen
    @Published var showCompletion: Bool = false
    @Published var checkedRowClues: [[Bool]] = []
    @Published var checkedColClues: [[Bool]] = []

    @AppStorage("autoX") private var autoX = false
    @AppStorage("autoCheckmark") private var autoCheckmark = false

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

    var isComplete: Bool {
        for row in 0..<nonogram.rows {
            for col in 0..<nonogram.cols {
                let shouldBeFilled = nonogram.solution[row][col]
                let isFilled = grid[row][col] == .filled
                if shouldBeFilled != isFilled { return false }
            }
        }
        return true
    }

    /// True for cells that count as "not filled" (crossed manually or auto-crossed)
    private func isCrossedState(_ state: CellState) -> Bool {
        state == .crossed || state == .autoCrossed
    }

    func beginDrag(at coord: GridCoord) {
        lockIfNeeded()
        visitedInDrag = []
        dragTargetState = targetState(for: coord)
        apply(targetState: dragTargetState, at: coord)
    }

    func continueDrag(at coord: GridCoord) {
        guard !visitedInDrag.contains(coord) else { return }
        apply(targetState: dragTargetState, at: coord)
    }

    func endDrag() {
        visitedInDrag = []
        updateAutoFeatures()
        DailyPuzzleService.saveProgress(grid, difficulty: nonogram.difficulty)
        if isComplete {
            DailyPuzzleService.markSolved(difficulty: nonogram.difficulty)
            showCompletion = true
        }
    }

    func handleTap(at coord: GridCoord) {
        lockIfNeeded()
        let target = targetState(for: coord)
        apply(targetState: target, at: coord)
        updateAutoFeatures()
        DailyPuzzleService.saveProgress(grid, difficulty: nonogram.difficulty)
        if isComplete {
            DailyPuzzleService.markSolved(difficulty: nonogram.difficulty)
            showCompletion = true
        }
    }

    private func lockIfNeeded() {
        guard !didLockPuzzle else { return }
        didLockPuzzle = true
        PuzzleLockService.lockPuzzle(difficulty: nonogram.difficulty)
    }

    // MARK: - Auto Features

    private func updateAutoFeatures() {
        if autoX { applyAutoX() }
        if autoCheckmark {
            updateCheckedClues()
        } else {
            resetCheckedClues()
        }
    }

    private func resetCheckedClues() {
        checkedRowClues = nonogram.rowClues.map { Array(repeating: false, count: $0.count) }
        checkedColClues = nonogram.colClues.map { Array(repeating: false, count: $0.count) }
    }

    private func applyAutoX() {
        for row in 0..<nonogram.rows {
            let filledCount = grid[row].filter { $0 == .filled }.count
            let required = nonogram.rowClues[row].reduce(0, +)
            if filledCount == required && filledCount > 0 {
                for col in 0..<nonogram.cols where grid[row][col] == .empty {
                    grid[row][col] = .autoCrossed
                }
            }
        }
        for col in 0..<nonogram.cols {
            let filledCount = (0..<nonogram.rows).filter { grid[$0][col] == .filled }.count
            let required = nonogram.colClues[col].reduce(0, +)
            if filledCount == required && filledCount > 0 {
                for row in 0..<nonogram.rows where grid[row][col] == .empty {
                    grid[row][col] = .autoCrossed
                }
            }
        }
    }

    private func updateCheckedClues() {
        checkedRowClues = (0..<nonogram.rows).map { row in
            let sequence = filledSequences(in: grid[row].map { $0 == .filled })
            return matchClues(nonogram.rowClues[row], to: sequence)
        }
        checkedColClues = (0..<nonogram.cols).map { col in
            let column = (0..<nonogram.rows).map { grid[$0][col] == .filled }
            let sequence = filledSequences(in: column)
            return matchClues(nonogram.colClues[col], to: sequence)
        }
    }

    /// Returns lengths of all consecutive filled runs.
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

    /// Returns which clue indices are satisfied by the current filled sequences.
    private func matchClues(_ clues: [Int], to sequences: [Int]) -> [Bool] {
        guard sequences != clues else {
            return Array(repeating: true, count: clues.count)
        }
        var result = Array(repeating: false, count: clues.count)
        // Left pass: match clues from the left
        var si = 0
        for (ci, clue) in clues.enumerated() {
            if si < sequences.count && sequences[si] == clue {
                result[ci] = true
                si += 1
            } else {
                break
            }
        }
        // Right pass: match remaining unmatched clues from the right
        var siR = sequences.count - 1
        for ci in stride(from: clues.count - 1, through: 0, by: -1) {
            if result[ci] { break }
            if siR >= 0 && sequences[siR] == clues[ci] {
                result[ci] = true
                siR -= 1
            } else {
                break
            }
        }
        return result
    }

    // MARK: - Private

    private func targetState(for coord: GridCoord) -> CellState {
        let current = grid[coord.row][coord.col]
        switch currentTool {
        case .pen:
            return current == .filled ? .empty : .filled
        case .eraser:
            return .empty
        case .marker:
            return current == .crossed ? .empty : .crossed
        }
    }

    private func apply(targetState: CellState, at coord: GridCoord) {
        guard coord.row >= 0, coord.row < nonogram.rows,
              coord.col >= 0, coord.col < nonogram.cols else { return }
        visitedInDrag.insert(coord)
        grid[coord.row][coord.col] = targetState
    }
}

struct GridCoord: Hashable {
    let row: Int
    let col: Int
}
