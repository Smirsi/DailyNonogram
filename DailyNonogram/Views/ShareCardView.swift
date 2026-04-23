import SwiftUI

// MARK: - Share Card View (rendered to image via ImageRenderer)

struct ShareCardView: View {
    let nonogram: Nonogram
    let streak: Int

    private let cardWidth: CGFloat = 360
    private let bgLight = Color(red: 0.973, green: 0.961, blue: 0.941) // #F8F5F0

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 4) {
                Text("🧩 Daily Nonogram")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(red: 0.1, green: 0.1, blue: 0.1))
                Text(formattedDate())
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color(red: 0.54, green: 0.52, blue: 0.50))
            }
            .padding(.top, 28)
            .padding(.bottom, 20)

            // Pixel grid
            SharePixelGridView(solution: nonogram.solution)
                .padding(.horizontal, 28)
                .padding(.bottom, 20)

            Rectangle()
                .fill(Color(red: 0.83, green: 0.81, blue: 0.79))
                .frame(height: 0.5)
                .padding(.horizontal, 28)

            // Stats
            HStack(spacing: 24) {
                if streak > 0 {
                    Label("\(streak) \(streak == 1 ? "Tag" : "Tage")", systemImage: "flame.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color(red: 0.769, green: 0.443, blue: 0.290))
                }
                Spacer()
                Text("daily-nonogram.app")
                    .font(.system(size: 11, weight: .regular, design: .monospaced))
                    .foregroundStyle(Color(red: 0.54, green: 0.52, blue: 0.50))
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
        }
        .frame(width: cardWidth)
        .background(bgLight)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: DailyPuzzleService.today())
    }
}

// MARK: - Pixel grid for share card (larger cells than the preview)

private struct SharePixelGridView: View {
    let solution: [[Bool]]

    var body: some View {
        let rows = solution.count
        let cols = solution.first?.count ?? 1
        let cellSize: CGFloat = min(12, 280 / CGFloat(max(rows, cols)))
        let width = CGFloat(cols) * cellSize
        let height = CGFloat(rows) * cellSize

        Canvas { ctx, _ in
            for row in 0..<rows {
                for col in 0..<cols {
                    let rect = CGRect(
                        x: CGFloat(col) * cellSize,
                        y: CGFloat(row) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )
                    let color = solution[row][col]
                        ? Color(red: 0.10, green: 0.10, blue: 0.10)
                        : Color(red: 0.93, green: 0.90, blue: 0.87)
                    ctx.fill(Path(rect), with: .color(color))
                }
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// MARK: - Image rendering helper

@MainActor
func renderShareCardImage(nonogram: Nonogram, streak: Int) -> UIImage? {
    let renderer = ImageRenderer(content: ShareCardView(nonogram: nonogram, streak: streak))
    renderer.scale = 3.0
    return renderer.uiImage
}
