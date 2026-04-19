import SwiftUI

struct DifficultySelectionView: View {
    let onSelect: (DifficultyLevel) -> Void
    let isPremium: Bool
    /// Difficulties already solved today
    let solvedToday: Set<DifficultyLevel>
    /// Date-based daily puzzle, if one exists for today
    var dailyPuzzle: DailyPuzzleResult? = nil

    @EnvironmentObject private var ads: AdManager

    @State private var pendingDifficulty: DifficultyLevel? = nil
    @State private var showConfirm = false
    @State private var showAdPrompt = false
    @State private var showSettings = false
    @State private var streak: Int = 0
    @State private var availableFreezes: Int = 0
    @State private var maxFreezes: Int = 0

    var body: some View {
        ZStack {
            DS.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Navigation bar area
                HStack {
                    Spacer()
                    Button {
                        showSettings = true
                    } label: {
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
                        // Title
                        Text("Daily Nonogram")
                            .font(DS.titleFont())
                            .foregroundStyle(DS.textPrimary)
                            .padding(.top, 8)

                        // Streak card
                        streakCard

                        // Puzzle selection
                        VStack(spacing: 12) {
                            if let daily = dailyPuzzle {
                                let level = daily.difficulty
                                let isSolved = solvedToday.contains(level)
                                DailyPuzzleButton(
                                    puzzle: daily.puzzle,
                                    difficulty: level,
                                    isSolved: isSolved,
                                    onTap: {
                                        guard !isSolved else { return }
                                        if isPremium {
                                            onSelect(level)
                                        } else if PuzzleLockService.lockedDifficulty() == level {
                                            onSelect(level)
                                        } else {
                                            pendingDifficulty = level
                                            showConfirm = true
                                        }
                                    }
                                )
                            } else {
                                ForEach(DifficultyLevel.allCases.filter { !$0.isColor }, id: \.self) { level in
                                    DifficultyButton(
                                        level: level,
                                        isSolved: solvedToday.contains(level),
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
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .confirmationDialog(
            "Rätsel bestätigen",
            isPresented: $showConfirm,
            titleVisibility: .visible
        ) {
            if let level = pendingDifficulty {
                Button(dailyPuzzle != nil ? "\(dailyPuzzle!.puzzle.title) spielen" : "\(level.displayName) spielen") {
                    onSelect(level)
                }
            }
            Button("Abbrechen", role: .cancel) { pendingDifficulty = nil }
        } message: {
            if dailyPuzzle != nil {
                Text("Du startest das heutige Rätsel. Diese Wahl kann heute nicht mehr geändert werden.")
            } else if let level = pendingDifficulty {
                Text("Du wählst \(level.displayName) (\(level.description)). Diese Wahl kann heute nicht mehr geändert werden.")
            }
        }
        .confirmationDialog(
            "Weiteres Rätsel spielen?",
            isPresented: $showAdPrompt,
            titleVisibility: .visible
        ) {
            if let level = pendingDifficulty {
                Button("Werbung ansehen") {
                    showRewardedAd(for: level)
                }
            }
            Button("Abbrechen", role: .cancel) { pendingDifficulty = nil }
        } message: {
            Text("Schau eine kurze Werbung an, um dieses Rätsel spielen zu können.")
        }
    }

    // MARK: - Streak Card

    private var streakCard: some View {
        VStack(spacing: 12) {
            // Streak number + flame
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(streak > 0 ? DS.accent : DS.textTertiary)
                Text(streak > 0 ? "\(streak) \(streak == 1 ? "Tag" : "Tage") in Folge" : "Noch kein Streak")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(streak > 0 ? DS.textPrimary : DS.textTertiary)
            }

            // 7-day progress bar
            WeekProgressView(streak: streak)
                .background(DS.surface, in: RoundedRectangle(cornerRadius: 10))

            // Freeze counter
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

    // MARK: - Tap handling

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
            pendingDifficulty = level
            showConfirm = true
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
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(DS.gridLine, lineWidth: 1)
            )
            .opacity(isSolved ? 0.6 : 1.0)
        }
        .disabled(isSolved)
        .buttonStyle(.plain)
    }
}

// MARK: - Difficulty Button (fallback)

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
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(DS.gridLine, lineWidth: 1)
            )
            .opacity(isSolved ? 0.6 : 1.0)
        }
        .disabled(isSolved)
        .buttonStyle(.plain)
    }
}
