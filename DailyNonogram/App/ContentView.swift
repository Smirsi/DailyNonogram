import SwiftUI

extension Notification.Name {
    static let showTutorial = Notification.Name("showTutorial")
}

struct ContentView: View {
    @EnvironmentObject private var store: StoreKitManager
    @State private var selectedDifficulty: DifficultyLevel? = DailyPuzzleService.selectedDifficulty()
    @AppStorage("hasSeenTutorial") private var hasSeenTutorial = false
    @State private var showTutorial = false

    var body: some View {
        Group {
            if let difficulty = selectedDifficulty {
                PuzzleContainerView(
                    difficulty: difficulty,
                    isPremium: store.isPremium,
                    onChangeDifficulty: {
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
        .overlay {
            if showTutorial {
                TutorialView {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showTutorial = false
                        hasSeenTutorial = true
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.easeOut(duration: 0.3), value: showTutorial)
        .onAppear {
            if !hasSeenTutorial {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    showTutorial = true
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showTutorial)) { _ in
            showTutorial = true
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
