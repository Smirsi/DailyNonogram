import SwiftUI

struct PremiumTeaserView: View {
    let onUpgrade: () -> Void
    let onDismiss: () -> Void

    @State private var appeared = false

    private let features: [(icon: String, text: String)] = [
        ("trophy.fill",          "Alle 3 Schwierigkeitsgrade täglich"),
        ("calendar.badge.clock", "Zugriff auf die ganze Woche"),
        ("xmark.circle.fill",    "Keine Werbung"),
        ("paintpalette.fill",    "Bald: Farbige Nonogramme")
    ]

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 0) {
                // Crown
                Image(systemName: "crown.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(DS.accent)
                    .padding(.top, 28)
                    .padding(.bottom, 12)

                Text("Mehr aus deinen Rätseln rausholen!")
                    .font(DS.titleFont())
                    .foregroundStyle(DS.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)

                Rectangle()
                    .fill(DS.separator)
                    .frame(height: 0.5)
                    .padding(.vertical, 20)

                // Feature list
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(features, id: \.text) { feature in
                        HStack(spacing: 12) {
                            Image(systemName: feature.icon)
                                .font(.system(size: 16))
                                .foregroundStyle(DS.accent)
                                .frame(width: 24)
                            Text(feature.text)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(DS.textPrimary)
                        }
                    }
                }
                .padding(.horizontal, 8)

                Rectangle()
                    .fill(DS.separator)
                    .frame(height: 0.5)
                    .padding(.vertical, 20)

                // Buttons
                VStack(spacing: 10) {
                    Button {
                        onUpgrade()
                    } label: {
                        Text("Premium werden")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(DS.accent, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)

                    Button {
                        onDismiss()
                    } label: {
                        Text("Vielleicht später")
                            .font(.system(size: 14))
                            .foregroundStyle(DS.textSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(28)
            .background(DS.background, in: RoundedRectangle(cornerRadius: DS.completionRadius))
            .shadow(color: .black.opacity(0.12), radius: 32, x: 0, y: 8)
            .padding(.horizontal, 32)
            .scaleEffect(appeared ? 1.0 : 0.92)
            .opacity(appeared ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.easeOut(duration: 0.3)) {
                    appeared = true
                }
            }
        }
    }
}
