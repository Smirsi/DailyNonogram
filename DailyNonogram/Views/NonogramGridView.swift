import SwiftUI

struct NonogramGridView: View {
    @ObservedObject var vm: NonogramViewModel
    let cellSize: CGFloat
    /// Persisted zoom level — updated when pinch ends
    @Binding var scale: CGFloat
    /// Live zoom level — updated every gesture frame, shared with CluesView via BoardView
    @Binding var liveScale: CGFloat

    private let minScale: CGFloat = 0.5
    private let maxScale: CGFloat = 3.0

    private var effectiveCellSize: CGFloat { cellSize * liveScale }

    var body: some View {
        let rows = vm.nonogram.rows
        let cols = vm.nonogram.cols
        let totalWidth = CGFloat(cols) * effectiveCellSize
        let totalHeight = CGFloat(rows) * effectiveCellSize

        Canvas { ctx, _ in
            // Cell backgrounds
            for row in 0..<rows {
                for col in 0..<cols {
                    let rect = cellRect(row: row, col: col)
                    switch vm.grid[row][col] {
                    case .filled:
                        ctx.fill(Path(rect), with: .color(DS.filled))
                    case .hinted:
                        ctx.fill(Path(rect), with: .color(DS.hintedCell))
                    case .error:
                        ctx.fill(Path(rect), with: .color(DS.errorCell.opacity(0.25)))
                    case .crossed:
                        ctx.fill(Path(rect), with: .color(DS.crossed))
                    case .autoCrossed:
                        ctx.fill(Path(rect), with: .color(DS.accent.opacity(0.12)))
                    case .empty:
                        ctx.fill(Path(rect), with: .color(DS.background))
                    }
                }
            }

            // Thin grid lines
            var gridPath = Path()
            for col in 0...cols {
                let x = CGFloat(col) * effectiveCellSize
                gridPath.move(to: CGPoint(x: x, y: 0))
                gridPath.addLine(to: CGPoint(x: x, y: totalHeight))
            }
            for row in 0...rows {
                let y = CGFloat(row) * effectiveCellSize
                gridPath.move(to: CGPoint(x: 0, y: y))
                gridPath.addLine(to: CGPoint(x: totalWidth, y: y))
            }
            ctx.stroke(gridPath, with: .color(DS.gridLine), lineWidth: 0.5)

            // Bold section dividers every 5 cells
            var boldPath = Path()
            for col in stride(from: 0, through: cols, by: 5) {
                let x = CGFloat(col) * effectiveCellSize
                boldPath.move(to: CGPoint(x: x, y: 0))
                boldPath.addLine(to: CGPoint(x: x, y: totalHeight))
            }
            for row in stride(from: 0, through: rows, by: 5) {
                let y = CGFloat(row) * effectiveCellSize
                boldPath.move(to: CGPoint(x: 0, y: y))
                boldPath.addLine(to: CGPoint(x: totalWidth, y: y))
            }
            ctx.stroke(boldPath, with: .color(DS.boldLine), lineWidth: 1.0)

            // X marks for .crossed, .autoCrossed, .error cells
            for row in 0..<rows {
                for col in 0..<cols {
                    let state = vm.grid[row][col]
                    let isX = state == .crossed || state == .autoCrossed || state == .error
                    guard isX else { continue }
                    let inset = effectiveCellSize * 0.15
                    let rect = cellRect(row: row, col: col).insetBy(dx: inset, dy: inset)
                    var xPath = Path()
                    xPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
                    xPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                    xPath.move(to: CGPoint(x: rect.maxX, y: rect.minY))
                    xPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                    let markColor: Color
                    switch state {
                    case .autoCrossed: markColor = DS.accent
                    case .error:       markColor = DS.errorCell
                    default:           markColor = DS.crossedMark
                    }
                    ctx.stroke(xPath, with: .color(markColor), lineWidth: max(1.0, liveScale * 0.9))
                }
            }
        }
        .frame(width: totalWidth, height: totalHeight)
        .clipShape(RoundedRectangle(cornerRadius: DS.outerBorderRadius))
        .overlay(
            RoundedRectangle(cornerRadius: DS.outerBorderRadius)
                .stroke(DS.border, lineWidth: 1.5)
        )
        // 1-finger draw
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { value in
                    let coord = gridCoord(at: value.location)
                    if value.translation == .zero {
                        vm.beginDrag(at: coord)
                    } else {
                        vm.continueDrag(at: coord)
                    }
                }
                .onEnded { _ in vm.endDrag() }
        )
        // 2-finger pinch zoom
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    liveScale = min(maxScale, max(minScale, scale * value))
                }
                .onEnded { value in
                    scale = min(maxScale, max(minScale, scale * value))
                    liveScale = scale
                }
        )
        // Double tap resets zoom
        .onTapGesture(count: 2) {
            withAnimation(.spring(response: 0.3)) {
                scale = 1.0
                liveScale = 1.0
            }
        }
    }

    // MARK: - Helpers

    private func cellRect(row: Int, col: Int) -> CGRect {
        CGRect(
            x: CGFloat(col) * effectiveCellSize,
            y: CGFloat(row) * effectiveCellSize,
            width: effectiveCellSize,
            height: effectiveCellSize
        )
    }

    private func gridCoord(at point: CGPoint) -> GridCoord {
        let col = Int(point.x / effectiveCellSize)
        let row = Int(point.y / effectiveCellSize)
        return GridCoord(
            row: max(0, min(vm.nonogram.rows - 1, row)),
            col: max(0, min(vm.nonogram.cols - 1, col))
        )
    }
}
