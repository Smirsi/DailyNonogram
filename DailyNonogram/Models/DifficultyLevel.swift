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
        case .easy:   return "Klein · bis 10×10 Felder"
        case .medium: return "Mittel · bis 15×15 Felder"
        case .hard:   return "Groß · bis 25×25 Felder"
        }
    }

    var subdirectory: String { rawValue }
}
