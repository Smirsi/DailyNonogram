import SwiftUI

struct CompletionOverlayView: View {
    let nonogram: Nonogram
    let streak: Int
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

                Text("Puzzle gelöst!")
                    .font(DS.completionHeadlineFont())
                    .foregroundStyle(DS.textPrimary)
                    .padding(.bottom, 16)

                SolvedPixelArtView(solution: nonogram.solution)
                    .padding(.bottom, 8)

                Text(formattedDate())
                    .font(DS.dateLabelFont())
                    .foregroundStyle(DS.textTertiary)
                    .padding(.top, 4)

                if streak > 0 {
                    HStack(spacing: 6) {
                        Text("🔥")
                            .font(.system(size: 18))
                        Text("\(streak) \(streak == 1 ? "Tag" : "Tage") in Folge")
                            .font(.system(size: 15, weight: .semibold, design: .monospaced))
                            .foregroundStyle(DS.accent)
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(DS.accent.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 12)
                }

                Rectangle()
                    .fill(DS.separator)
                    .frame(height: 0.5)
                    .padding(.vertical, 24)

                Button {
                    onDismiss()
                } label: {
                    Text("Weiter")
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
                withAnimation(.easeOut(duration: 0.35)) {
                    appeared = true
                }
            }
        }
    }

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: DailyPuzzleService.today())
    }
}

// MARK: - Pixel art preview of the solved puzzle

private struct SolvedPixelArtView: View {
    let solution: [[Bool]]

    private let maxSize: CGFloat = 120

    var body: some View {
        let rows = solution.count
        let cols = solution.first?.count ?? 1
        let cellSize = min(maxSize / CGFloat(max(rows, cols)), 8)
        let width = CGFloat(cols) * cellSize
        let height = CGFloat(rows) * cellSize

        Canvas { ctx, _ in
            for row in 0..<rows {
                for col in 0..<cols where solution[row][col] {
                    let rect = CGRect(
                        x: CGFloat(col) * cellSize,
                        y: CGFloat(row) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )
                    ctx.fill(Path(rect), with: .color(DS.filled))
                }
            }
        }
        .frame(width: width, height: height)
        .background(DS.surface)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(DS.gridLine, lineWidth: 0.5)
        )
    }
}
