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
        case .easy:        return String(localized: "Klein")
        case .medium:      return String(localized: "Mittel")
        case .hard:        return String(localized: "Groß")
        case .colorEasy:   return String(localized: "Farbe — Klein")
        case .colorMedium: return String(localized: "Farbe — Mittel")
        case .colorHard:   return String(localized: "Farbe — Groß")
        }
    }

    var description: String {
        switch self {
        case .easy:        return String(localized: "Klein · bis 10×10 Felder")
        case .medium:      return String(localized: "Mittel · bis 15×15 Felder")
        case .hard:        return String(localized: "Groß · bis 25×25 Felder")
        case .colorEasy:   return String(localized: "Farbe · 5×5–8×8 · 2–3 Farben")
        case .colorMedium: return String(localized: "Farbe · 8×8–12×12 · 2–4 Farben")
        case .colorHard:   return String(localized: "Farbe · 12×12–20×20 · 3–5 Farben")
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
