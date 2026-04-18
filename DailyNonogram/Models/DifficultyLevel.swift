import Foundation

enum DifficultyLevel: String, Codable, CaseIterable, Sendable {
    case easy        = "easy"
    case medium      = "medium"
    case hard        = "hard"
    case colorEasy   = "color-easy"
    case colorMedium = "color-medium"
    case colorHard   = "color-hard"

    var displayName: String {
        switch self {
        case .easy:        return "Einfach"
        case .medium:      return "Mittel"
        case .hard:        return "Schwer"
        case .colorEasy:   return "Farbe — Einfach"
        case .colorMedium: return "Farbe — Mittel"
        case .colorHard:   return "Farbe — Schwer"
        }
    }

    var description: String {
        switch self {
        case .easy:        return "Klein · bis 10×10 Felder"
        case .medium:      return "Mittel · bis 15×15 Felder"
        case .hard:        return "Groß · bis 25×25 Felder"
        case .colorEasy:   return "Farbe · 5×5–8×8 · 2–3 Farben"
        case .colorMedium: return "Farbe · 8×8–12×12 · 2–4 Farben"
        case .colorHard:   return "Farbe · 12×12–20×20 · 3–5 Farben"
        }
    }

    var isColor: Bool {
        switch self {
        case .colorEasy, .colorMedium, .colorHard: return true
        default: return false
        }
    }

    var subdirectory: String { rawValue }
}
