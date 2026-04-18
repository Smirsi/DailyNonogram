import Foundation

struct PuzzleLibrary {

    // MARK: - B&W Collections
    static let easy: [Nonogram]   = FreeNonoPuzzleLoader.load(difficulty: .easy)
    static let medium: [Nonogram] = FreeNonoPuzzleLoader.load(difficulty: .medium)
    static let hard: [Nonogram]   = FreeNonoPuzzleLoader.load(difficulty: .hard)

    // MARK: - Color Collections (data layer only — UI not yet implemented)
    static let colorEasy: [Nonogram]   = ColorNonogramLoader.load(difficulty: .colorEasy)
    static let colorMedium: [Nonogram] = ColorNonogramLoader.load(difficulty: .colorMedium)
    static let colorHard: [Nonogram]   = ColorNonogramLoader.load(difficulty: .colorHard)

    // MARK: - Lookup

    static func puzzles(for difficulty: DifficultyLevel) -> [Nonogram] {
        switch difficulty {
        case .easy:        return easy
        case .medium:      return medium
        case .hard:        return hard
        case .colorEasy:   return colorEasy
        case .colorMedium: return colorMedium
        case .colorHard:   return colorHard
        }
    }
}
