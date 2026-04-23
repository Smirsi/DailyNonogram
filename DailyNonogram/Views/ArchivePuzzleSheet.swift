import SwiftUI

/// Identifiable wrapper for a past date selection (used by `.sheet(item:)`).
struct ArchiveDateSelection: Identifiable {
    let id = UUID()
    let date: Date
}

/// Sheet that lets premium users replay a past day's puzzle.
struct ArchivePuzzleSheet: View {
    let date: Date
    let difficulty: DifficultyLevel

    @StateObject private var vm: NonogramViewModel
    @Environment(\.dismiss) private var dismiss

    init(date: Date, difficulty: DifficultyLevel) {
        self.date = date
        self.difficulty = difficulty
        let puzzle = DailyPuzzleService.puzzle(for: date, difficulty: difficulty)
        let saved  = DailyPuzzleService.loadProgress(for: date, difficulty: difficulty)
        _vm = StateObject(wrappedValue: NonogramViewModel(nonogram: puzzle, savedGrid: saved))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                DS.background.ignoresSafeArea()
                ArchiveBoardView(vm: vm, date: date, difficulty: difficulty)
            }
            .navigationTitle(formattedDate())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Schließen") { dismiss() }
                }
            }
        }
        .overlay {
            if vm.showCompletion {
                ArchiveCompletionView(puzzleTitle: vm.nonogram.title) { dismiss() }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .animation(.easeOut(duration: 0.3), value: vm.showCompletion)
            }
        }
        .onDisappear {
            // Persist progress when closing (in case puzzle wasn't completed)
            DailyPuzzleService.saveProgress(vm.grid, for: date, difficulty: difficulty)
        }
    }

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.dateFormat = "EEEE, d. MMMM"
        return f.string(from: date)
    }
}

// MARK: - Board view for archive puzzle (saves progress automatically)

private struct ArchiveBoardView: View {
    @ObservedObject var vm: NonogramViewModel
    let date: Date
    let difficulty: DifficultyLevel

    @AppStorage("showCluesBothSides") private var showCluesBothSides = false
    private let cellSize: CGFloat = 36
    private let minScale: CGFloat = 0.3
    private let maxScale: CGFloat = 3.0
    @State private var scale: CGFloat = 1.0
    @State private var liveScale: CGFloat = 1.0
    @State private var isPinching = false

    private var effectiveCellSize: CGFloat { cellSize * liveScale }
    private var rowClueWidth: CGFloat {
        CGFloat((vm.nonogram.rowClues.map(\.count).max() ?? 1)) * 18 * liveScale + 8
    }
    private var colClueHeight: CGFloat {
        CGFloat((vm.nonogram.colClues.map(\.count).max() ?? 1)) * 18 * liveScale + 8
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(vm.nonogram.difficulty.displayName)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(DS.accent)
                .padding(.horizontal, 10)
                .padding(.vertical, 3)
                .background(DS.accent.opacity(0.12))
                .clipShape(Capsule())
                .padding(.top, 8)

            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Color.clear.frame(width: rowClueWidth, height: colClueHeight)
                        ColCluesView(clues: vm.nonogram.colClues,
                                     cellSize: effectiveCellSize,
                                     checkedClues: vm.checkedColClues)
                            .frame(height: colClueHeight)
                        if showCluesBothSides {
                            Color.clear.frame(width: rowClueWidth, height: colClueHeight)
                        }
                    }
                    HStack(alignment: .top, spacing: 0) {
                        RowCluesView(clues: vm.nonogram.rowClues,
                                     cellSize: effectiveCellSize,
                                     checkedClues: vm.checkedRowClues)
                            .frame(width: rowClueWidth)
                        NonogramGridView(vm: vm, cellSize: cellSize, scale: $scale,
                                         liveScale: $liveScale, isPinching: $isPinching)
                        if showCluesBothSides {
                            RowCluesView(clues: vm.nonogram.rowClues,
                                         cellSize: effectiveCellSize,
                                         checkedClues: vm.checkedRowClues,
                                         alignRight: false)
                                .frame(width: rowClueWidth)
                        }
                    }
                }
                .padding(16)
            }
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        isPinching = true
                        liveScale = min(maxScale, max(minScale, scale * value))
                    }
                    .onEnded { value in
                        scale = min(maxScale, max(minScale, scale * value))
                        liveScale = scale
                        isPinching = false
                    }
            )
            ToolbarView(currentTool: $vm.currentTool)
                .padding(.top, 16)
                .padding(.bottom, 8)
        }
        .onChange(of: vm.grid) { _, _ in
            DailyPuzzleService.saveProgress(vm.grid, for: date, difficulty: difficulty)
        }
    }
}

// MARK: - Completion card for archive puzzle

private struct ArchiveCompletionView: View {
    let puzzleTitle: String
    let onDismiss: () -> Void
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 0) {
                Image(systemName: "checkmark")
                    .font(.system(size: 44, weight: .light))
                    .foregroundStyle(DS.accent)
                    .padding(.bottom, 20)

                Text("Gelöst!")
                    .font(DS.completionHeadlineFont())
                    .foregroundStyle(DS.textPrimary)
                    .padding(.bottom, 8)

                Text(puzzleTitle)
                    .font(.custom("Georgia", size: 17).weight(.regular))
                    .foregroundStyle(DS.textSecondary)

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
