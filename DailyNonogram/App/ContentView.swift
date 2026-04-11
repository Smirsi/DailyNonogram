import SwiftUI

struct ContentView: View {
    @StateObject private var vm: NonogramViewModel = {
        let puzzle = DailyPuzzleService.todaysPuzzle()
        let saved = DailyPuzzleService.loadProgress()
        return NonogramViewModel(nonogram: puzzle, savedGrid: saved)
    }()

    var body: some View {
        NonogramBoardView(vm: vm)
    }
}

#Preview {
    ContentView()
}
