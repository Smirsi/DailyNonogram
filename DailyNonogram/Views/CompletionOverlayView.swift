import SwiftUI

struct CompletionOverlayView: View {
    let nonogram: Nonogram
    let streak: Int
    let onDismiss: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 0) {
                // Flame + streak
                VStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 48, weight: .regular))
                        .foregroundStyle(streak > 0 ? DS.accent : DS.textTertiary)

                    if streak > 0 {
                        Text("\(streak)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(DS.textPrimary)
                        Text(streak == 1 ? "Tag in Folge" : "Tage in Folge")
                            .font(DS.dateLabelFont())
                            .foregroundStyle(DS.textSecondary)
                    }
                }
                .padding(.bottom, 20)

                // Pixel art
                SolvedPixelArtView(solution: nonogram.solution)
                    .padding(.bottom, 14)

                // Title
                Text("Gelöst!")
                    .font(DS.completionHeadlineFont())
                    .foregroundStyle(DS.textPrimary)
                    .padding(.bottom, 4)

                Text(nonogram.title)
                    .font(DS.dateLabelFont())
                    .foregroundStyle(DS.textSecondary)
                    .padding(.bottom, 2)

                Text(formattedDate())
                    .font(DS.dateLabelFont())
                    .foregroundStyle(DS.textTertiary)
                    .padding(.bottom, 28)

                // Share + CTA
                HStack(spacing: 12) {
                    Button {
                        if let img = renderShareCardImage(nonogram: nonogram, streak: streak) {
                            showShare(image: img)
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(DS.accent)
                            .frame(width: 48, height: 48)
                            .background(DS.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)

                    Button { onDismiss() } label: {
                        Text("Weiter")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(DS.accent, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 36)
            .background(DS.background, in: RoundedRectangle(cornerRadius: DS.completionRadius))
            .shadow(color: .black.opacity(0.14), radius: 40, x: 0, y: 10)
            .padding(.horizontal, 36)
            .scaleEffect(appeared ? 1.0 : 0.88)
            .opacity(appeared ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                    appeared = true
                }
            }
        }
    }

    private func showShare(image: UIImage) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        // iPad: popover needs an anchor, otherwise blank sheet
        if let popover = vc.popoverPresentationController {
            popover.sourceView = rootVC.view
            popover.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        rootVC.present(vc, animated: true)
    }

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.locale = Locale.current
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: DailyPuzzleService.today())
    }
}

// MARK: - Pixel art preview of the solved puzzle

private struct SolvedPixelArtView: View {
    let solution: [[Bool]]

    private let maxSize: CGFloat = 110

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
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(DS.gridLine, lineWidth: 0.5))
    }
}

