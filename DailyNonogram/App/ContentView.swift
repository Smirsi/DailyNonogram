import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: StoreKitManager
    @State private var selectedDifficulty: DifficultyLevel? = DailyPuzzleService.selectedDifficulty()

    var body: some View {
        if let difficulty = selectedDifficulty {
            PuzzleContainerView(
                difficulty: difficulty,
                isPremium: store.isPremium,
                onChangeDifficulty: {
                    // Premium: allow returning to difficulty selection
                    selectedDifficulty = nil
                }
            )
        } else {
            DifficultySelectionView(
                onSelect: { diff in
                    DailyPuzzleService.saveDifficulty(diff)
                    selectedDifficulty = diff
                },
                isPremium: store.isPremium,
                solvedToday: solvedDifficultiesForToday(),
                dailyPuzzles: DailyPuzzleService.todaysDailyPuzzles()
            )
        }
    }

    private func solvedDifficultiesForToday() -> Set<DifficultyLevel> {
        Set(DifficultyLevel.allCases.filter {
            DailyPuzzleService.wasSolved(for: DailyPuzzleService.today(), difficulty: $0)
        })
    }
}

// MARK: - Puzzle Container

/// Holds the @StateObject so it is properly re-created when difficulty changes.
private struct PuzzleContainerView: View {
    let difficulty: DifficultyLevel
    let isPremium: Bool
    let onChangeDifficulty: () -> Void

    @StateObject private var vm: NonogramViewModel

    init(difficulty: DifficultyLevel, isPremium: Bool, onChangeDifficulty: @escaping () -> Void) {
        self.difficulty = difficulty
        self.isPremium = isPremium
        self.onChangeDifficulty = onChangeDifficulty
        let puzzle = DailyPuzzleService.todaysPuzzle(difficulty: difficulty)
        let saved  = DailyPuzzleService.loadProgress(difficulty: difficulty)
        _vm = StateObject(wrappedValue: NonogramViewModel(nonogram: puzzle, savedGrid: saved))
    }

    var body: some View {
        NonogramBoardView(
            vm: vm,
            onChangeDifficulty: onChangeDifficulty
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(StoreKitManager())
}
