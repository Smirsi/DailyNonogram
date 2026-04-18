import SwiftUI

/// Small banner shown after solving the daily puzzle, offering a rewarded bonus puzzle.
struct BonusOfferBanner: View {
    let rewardedReady: Bool
    let onTap: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Bonus-Rätsel")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(DS.textPrimary)
                Text("Kurze Werbung anschauen und ein Extra-Rätsel spielen")
                    .font(.system(size: 11))
                    .foregroundStyle(DS.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            if rewardedReady {
                Button(action: onTap) {
                    Text("Spielen")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(DS.accent, in: Capsule())
                }
                .buttonStyle(.plain)
            } else {
                ProgressView()
                    .scaleEffect(0.8)
            }

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(DS.textTertiary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(DS.surface, in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(DS.separator, lineWidth: 0.5)
        )
        .padding(.horizontal, 8)
    }
}
