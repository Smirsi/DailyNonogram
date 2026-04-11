import Foundation

enum DifficultyLevel: String, Codable, CaseIterable, Sendable {
    case easy   = "easy"
    case medium = "medium"
    case hard   = "hard"

    var displayName: String {
        switch self {
        case .easy:   return "Einfach"
        case .medium: return "Mittel"
        case .hard:   return "Schwer"
        }
    }

    var description: String {
        switch self {
        case .easy:   return "10×10 · 100 Felder"
        case .medium: return "15×15 · 225 Felder"
        case .hard:   return "25×25 · 625 Felder"
        }
    }

    var subdirectory: String { rawValue }
}
