import SwiftUI

// MARK: - Step Model

struct TutorialStep {
    let icon: String
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    let iconColor: Color
}

// MARK: - Tutorial View

struct TutorialView: View {
    let onFinish: () -> Void

    private let steps: [TutorialStep] = [
        TutorialStep(
            icon: "square.grid.3x3.fill",
            title: "Willkommen!",
            description: "Ein Nonogramm ist ein Bilderrätsel. Die Zahlen am Rand geben an, wie viele Felder hintereinander gefüllt sein müssen.",
            iconColor: .accentColor
        ),
        TutorialStep(
            icon: "pencil",
            title: "Felder füllen",
            description: "Tippe auf eine Zelle oder wische über mehrere Zellen, um sie zu füllen. Tippe erneut, um sie zu leeren.",
            iconColor: .accentColor
        ),
        TutorialStep(
            icon: "xmark.square",
            title: "Radierer & Markierung",
            description: "Nutze den Radierer, um Felder zu leeren. Mit der Markierung setzt du ein X in Felder, die leer bleiben müssen.",
            iconColor: .accentColor
        ),
        TutorialStep(
            icon: "lightbulb.fill",
            title: "Hinweise & Hilfe",
            description: "Wenn du nicht weiterkommst, gibt dir ein Hint einen Tipp. Du hast pro Rätsel eine begrenzte Anzahl.",
            iconColor: .yellow
        ),
        TutorialStep(
            icon: "flame.fill",
            title: "Tägliches Rätsel",
            description: "Jeden Tag gibt es ein neues Nonogramm. Löse es täglich und halte deinen Streak am Laufen!",
            iconColor: .orange
        ),
    ]

    @State private var currentStep = 0
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.78)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Card
                VStack(spacing: 0) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(steps[currentStep].iconColor.opacity(0.15))
                            .frame(width: 88, height: 88)
                        Image(systemName: steps[currentStep].icon)
                            .font(.system(size: 38, weight: .light))
                            .foregroundStyle(steps[currentStep].iconColor)
                    }
                    .padding(.bottom, 20)

                    // Title
                    Text(steps[currentStep].title)
                        .font(.custom("Georgia", size: 22).weight(.regular))
                        .foregroundStyle(DS.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 12)

                    // Description
                    Text(steps[currentStep].description)
                        .font(.system(size: 15))
                        .foregroundStyle(DS.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 28)

                    // Page dots
                    HStack(spacing: 6) {
                        ForEach(steps.indices, id: \.self) { i in
                            Capsule()
                                .fill(i == currentStep ? DS.accent : DS.gridLine)
                                .frame(width: i == currentStep ? 18 : 6, height: 6)
                                .animation(.easeOut(duration: 0.2), value: currentStep)
                        }
                    }
                    .padding(.bottom, 20)

                    // Button
                    Button {
                        if currentStep < steps.count - 1 {
                            withAnimation(.easeOut(duration: 0.2)) {
                                currentStep += 1
                            }
                        } else {
                            onFinish()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text(currentStep < steps.count - 1 ? "Weiter" : "Los geht's")
                                .font(.system(size: 16, weight: .semibold))
                            if currentStep < steps.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(DS.accent, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
                .padding(28)
                .background(DS.background, in: RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.25), radius: 40, x: 0, y: 10)
                .padding(.horizontal, 24)

                Spacer().frame(height: 48)
            }
        }
        .scaleEffect(appeared ? 1 : 0.92)
        .opacity(appeared ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                appeared = true
            }
        }
    }
}
