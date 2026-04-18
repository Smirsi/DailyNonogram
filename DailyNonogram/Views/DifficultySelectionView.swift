import SwiftUI

struct DifficultySelectionView: View {
    let onSelect: (DifficultyLevel) -> Void
    let isPremium: Bool
    /// Difficulties already solved today (premium users can do multiple)
    let solvedToday: Set<DifficultyLevel>

    @State private var pendingDifficulty: DifficultyLevel? = nil
    @State private var showConfirm = false

    var body: some View {
        ZStack {
            DS.background.ignoresSafeArea()

            VStack(spacing: 32) {
                VStack(spacing: 6) {
                    Text("Tägliches Nonogramm")
                        .font(DS.titleFont())
                        .foregroundStyle(DS.textPrimary)
                    Text("Wähle deine Schwierigkeit")
                        .font(DS.dateLabelFont())
                        .foregroundStyle(DS.textSecondary)
                }
                .padding(.top, 48)

                VStack(spacing: 14) {
                    ForEach(DifficultyLevel.allCases.filter { !$0.isColor }, id: \.self) { level in
                        DifficultyButton(
                            level: level,
                            isSolved: solvedToday.contains(level),
                            onTap: {
                                if isPremium || !solvedToday.contains(level) {
                                    pendingDifficulty = level
                                    if isPremium {
                                        // Premium: no lock warning, select immediately
                                        onSelect(level)
                                    } else {
                                        showConfirm = true
                                    }
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)

                if !isPremium {
                    Text("Du kannst heute nur eine Schwierigkeit wählen.")
                        .font(DS.dateLabelFont())
                        .foregroundStyle(DS.textTertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()
            }
        }
        .confirmationDialog(
            "Schwierigkeit bestätigen",
            isPresented: $showConfirm,
            titleVisibility: .visible
        ) {
            if let level = pendingDifficulty {
                Button("\(level.displayName) spielen") {
                    onSelect(level)
                }
            }
            Button("Abbrechen", role: .cancel) {
                pendingDifficulty = nil
            }
        } message: {
            if let level = pendingDifficulty {
                Text("Du wählst \(level.displayName) (\(level.description)). Diese Wahl kann heute nicht mehr geändert werden.")
            }
        }
    }
}

// MARK: - Difficulty Button

private struct DifficultyButton: View {
    let level: DifficultyLevel
    let isSolved: Bool
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
