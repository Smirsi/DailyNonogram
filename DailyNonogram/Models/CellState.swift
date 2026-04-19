import Foundation

enum CellState: Int {
    case empty = 0
    case filled = 1
    case crossed = 2
    /// Automatically placed X (by autoX feature) — rendered in accent color
    case autoCrossed = 3
    /// Revealed via hint — counts as filled for solution check, shown in green
    case hinted = 4
    /// Wrong fill revealed by error-reveal feature — shown in red
    case error = 5
}

enum Tool: Identifiable {
    case pen
    case eraser
    case marker

    var id: String { "\(self)" }
}
