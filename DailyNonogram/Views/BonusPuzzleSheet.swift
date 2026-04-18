import SwiftUI

/// Modal sheet that lets the user play a single bonus puzzle (rewarded via ad).
struct BonusPuzzleSheet: View {
    let difficulty: DifficultyLevel

    @StateObject private var vm: NonogramViewModel
    @Environment(\.dismiss) private var dismiss

    init(difficulty: DifficultyLevel) {
        self.difficulty = difficulty
        let puzzle = DailyPuzzleService.bonusPuzzle(difficulty: difficulty)
        _vm = StateObject(wrappedValue: NonogramViewModel(nonogram: puzzle, savedGrid: nil))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                DS.background.ignoresSafeArea()
                BonusBoardView(vm: vm)
            }
            .navigationTitle("Bonus-Rätsel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Schließen") { dismiss() }
                }
            }
        }
        .overlay {
            if vm.showCompletion {
                BonusCompletionView { dismiss() }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .animation(.easeOut(duration: 0.3), value: vm.showCompletion)
            }
        }
    }
}

// MARK: - Simplified board for bonus (no ads, no premium gating, no daily context)

private struct BonusBoardView: View {
    @ObservedObject var vm: NonogramViewModel
    @AppStorage("showCluesBothSides") private var showCluesBothSides = false

    private let cellSize: CGFloat = 36
    @State private var scale: CGFloat = 1.0
    @State private var liveScale: CGFloat = 1.0

    private var effectiveCellSize: CGFloat { cellSize * liveScale }
    private var rowClueWidth: CGFloat {
        CGFloat((vm.nonogram.rowClues.map(\.count).max() ?? 1)) * 18 * liveScale + 8
    }
    private var colClueHeight: CGFloat {
        CGFloat((vm.nonogram.colClues.map(\.count).max() ?? 1)) * 18 * liveScale + 8
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Color.clear.frame(width: rowClueWidth, height: colClueHeight)
                        ColCluesView(clues: vm.nonogram.colClues,
                                     cellSize: effectiveCellSize,
                                     checkedClues: vm.checkedColClues)
                            .frame(height: colClueHeight)
                    }
                    HStack(alignment: .top, spacing: 0) {
                        RowCluesView(clues: vm.nonogram.rowClues,
                                     cellSize: effectiveCellSize,
                                     checkedClues: vm.checkedRowClues)
                            .frame(width: rowClueWidth)
                        NonogramGridView(vm: vm, cellSize: cellSize, scale: $scale, liveScale: $liveScale)
                    }
                }
                .padding(16)
            }
            ToolbarView(currentTool: $vm.currentTool)
                .padding(.top, 16)
                .padding(.bottom, 8)
        }
    }
}

// MARK: - Completion card for bonus puzzle

private struct BonusCompletionView: View {
    let onDismiss: () -> Void
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 0) {
                Image(systemName: "star.fill")
                    .font(.system(size: 44, weight: .light))
                    .foregroundStyle(DS.accent)
                    .padding(.bottom, 16)

                Text("Bonus gelöst!")
                    .font(DS.completionHeadlineFont())
                    .foregroundStyle(DS.textPrimary)
                    .padding(.bottom, 8)

                Text("Gut gemacht!")
                    .font(DS.dateLabelFont())
                    .foregroundStyle(DS.textTertiary)

                Rectangle()
                    .fill(DS.separator)
                    .frame(height: 0.5)
                    .padding(.vertical, 24)

                Button {
                    onDismiss()
                } label: {
                    Text("Schließen")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(DS.accent, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            .padding(32)
            .background(DS.background, in: RoundedRectangle(cornerRadius: DS.completionRadius))
            .shadow(color: .black.opacity(0.12), radius: 32, x: 0, y: 8)
            .padding(.horizontal, 40)
            .scaleEffect(appeared ? 1.0 : 0.92)
            .opacity(appeared ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.easeOut(duration: 0.35)) { appeared = true }
            }
        }
    }
}
