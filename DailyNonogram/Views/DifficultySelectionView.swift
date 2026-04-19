import SwiftUI

struct DifficultySelectionView: View {
    let onSelect: (DifficultyLevel) -> Void
    let isPremium: Bool
    let solvedToday: Set<DifficultyLevel>
    /// Date-based daily puzzles for today (one per difficulty)
    var dailyPuzzles: [DailyPuzzleResult] = []

    @EnvironmentObject private var ads: AdManager

    @State private var pendingDifficulty: DifficultyLevel? = nil
    @State private var showAdPrompt = false
    @State private var showSettings = false
    @State private var streak: Int = 0
    @State private var availableFreezes: Int = 0
    @State private var maxFreezes: Int = 0

    var body: some View {
        ZStack {
            DS.background.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button { showSettings = true } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundStyle(DS.textSecondary)
                            .padding(8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                ScrollView {
                    VStack(spacing: 24) {
                        Text("Daily Nonogram")
                            .font(DS.titleFont())
                            .foregroundStyle(DS.textPrimary)
                            .padding(.top, 8)

                        streakCard

                        // Always show all 3 non-color difficulties
                        VStack(spacing: 12) {
                            ForEach(DifficultyLevel.allCases.filter { !$0.isColor }, id: \.self) { level in
                                let dailyForLevel = dailyPuzzles.first { $0.difficulty == level }
                                let isSolved = solvedToday.contains(level)

                                if let daily = dailyForLevel {
                                    DailyPuzzleButton(
                                        puzzle: daily.puzzle,
                                        difficulty: level,
                                        isSolved: isSolved,
                                        onTap: { handleTap(level: level) }
                                    )
                                } else {
                                    DifficultyButton(
                                        level: level,
                                        isSolved: isSolved,
                                        needsAd: !isPremium && PuzzleLockService.requiresAdToPlay(difficulty: level),
                                        onTap: { handleTap(level: level) }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .onAppear {
            streak = StreakService.currentStreak()
            let maxF = isPremium ? 10 : 5
            maxFreezes = maxF
            availableFreezes = StreakService.availableFreezes(isPremium: isPremium)
        }
        .sheet(isPresented: $showSettings) { SettingsView() }
        .confirmationDialog(
            "Weiteres Rätsel spielen?",
            isPresented: $showAdPrompt,
            titleVisibility: .visible
        ) {
            if let level = pendingDifficulty {
                Button("Werbung ansehen") { showRewardedAd(for: level) }
            }
            Button("Abbrechen", role: .cancel) { pendingDifficulty = nil }
        } message: {
            Text("Schau eine kurze Werbung an, um dieses Rätsel spielen zu können.")
        }
    }

    // MARK: - Streak Card

    private var streakCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(streak > 0 ? DS.accent : DS.textTertiary)
                Text(streak > 0 ? "\(streak) \(streak == 1 ? "Tag" : "Tage") in Folge" : "Noch kein Streak")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(streak > 0 ? DS.textPrimary : DS.textTertiary)
            }
            WeekProgressView(streak: streak)
                .background(DS.surface, in: RoundedRectangle(cornerRadius: 10))
            if availableFreezes > 0 || maxFreezes > 0 {
                HStack(spacing: 6) {
                    Image(systemName: "snowflake")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.blue.opacity(0.75))
                    Text("\(availableFreezes) / \(maxFreezes) Freezes verfügbar")
                        .font(.system(size: 13))
                        .foregroundStyle(DS.textSecondary)
                }
            }
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Tap Handling (DES6.2: confirmation dialog removed)

    private func handleTap(level: DifficultyLevel) {
        guard !solvedToday.contains(level) else { return }
        if isPremium {
            onSelect(level)
        } else if PuzzleLockService.lockedDifficulty() == level {
            onSelect(level)
        } else if PuzzleLockService.requiresAdToPlay(difficulty: level) {
            pendingDifficulty = level
            showAdPrompt = true
        } else {
            onSelect(level)
        }
    }

    private func showRewardedAd(for level: DifficultyLevel) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        ads.showRewardedIfReady(from: rootVC) {
            PuzzleLockService.unlockPuzzle(difficulty: level)
            onSelect(level)
        }
    }
}

// MARK: - Daily Puzzle Button

private struct DailyPuzzleButton: View {
    let puzzle: Nonogram
    let difficulty: DifficultyLevel
    let isSolved: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(puzzle.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(isSolved ? DS.textTertiary : DS.textPrimary)
                    Text("\(puzzle.cols)×\(puzzle.rows) · \(difficulty.displayName)")
                        .font(DS.dateLabelFont())
                        .foregroundStyle(DS.textSecondary)
                }
                Spacer()
                if isSolved {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(DS.accent)
                        .font(.system(size: 22))
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(DS.textTertiary)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(DS.surface)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(DS.gridLine, lineWidth: 1))
            .opacity(isSolved ? 0.6 : 1.0)
        }
        .disabled(isSolved)
        .buttonStyle(.plain)
    }
}

// MARK: - Difficulty Button (fallback when no daily puzzle)

private struct DifficultyButton: View {
    let level: DifficultyLevel
    let isSolved: Bool
    let needsAd: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(level.displayName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(isSolved ? DS.textTertiary : DS.textPrimary)
                    Text(level.description)
                        .font(DS.dateLabelFont())
                        .foregroundStyle(DS.textSecondary)
                }
                Spacer()
                if isSolved {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(DS.accent)
                        .font(.system(size: 22))
                } else if needsAd {
                    Image(systemName: "play.rectangle.fill")
                        .foregroundStyle(DS.textTertiary)
                        .font(.system(size: 18))
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(DS.textTertiary)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(DS.surface)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(DS.gridLine, lineWidth: 1))
            .opacity(isSolved ? 0.6 : 1.0)
        }
        .disabled(isSolved)
        .buttonStyle(.plain)
    }
}
