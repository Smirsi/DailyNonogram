import Foundation

struct PuzzleLibrary {

    // MARK: - Per-Difficulty Collections (30 puzzles each)

    static let easy: [Nonogram] = FreeNonoPuzzleLoader.load(difficulty: .easy)
    static let medium: [Nonogram] = FreeNonoPuzzleLoader.load(difficulty: .medium)
    static let hard: [Nonogram] = FreeNonoPuzzleLoader.load(difficulty: .hard)

    // MARK: - Lookup

    static func puzzles(for difficulty: DifficultyLevel) -> [Nonogram] {
        switch difficulty {
        case .easy:   return easy
        case .medium: return medium
        case .hard:   return hard
        }
    }
}
