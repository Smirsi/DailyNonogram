import Foundation

enum CellState: Int {
    case empty = 0
    case filled = 1
    case crossed = 2
    /// Automatically placed X (by autoX feature) — rendered in accent color
    case autoCrossed = 3
}

enum Tool: Identifiable {
    case pen
    case eraser
    case marker

    var id: String { "\(self)" }
}
