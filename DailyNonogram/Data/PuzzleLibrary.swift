import Foundation

struct PuzzleLibrary {
    /// All available puzzles: handcrafted + FreeNono XML puzzles from the bundle.
    static let all: [Nonogram] = {
        let handcrafted: [Nonogram] = [herz, baum, haus, fisch, katze, rakete, pilz, sonne, vogel, diamant]
        let external = FreeNonoPuzzleLoader.loadAll()
        return handcrafted + external
    }()

    // MARK: - Private helpers

    private static func grid(_ lines: [String]) -> [[Bool]] {
        lines.map { line in line.map { $0 == "X" } }
    }

    private static func puzzle(title: String, _ lines: [String]) -> Nonogram {
        let g = grid(lines)
        let clues = Nonogram.computeClues(from: g)
        return Nonogram(title: title, rows: g.count, cols: g[0].count,
                        rowClues: clues.rows, colClues: clues.cols, solution: g)
    }

    // MARK: - Puzzles (15×15)

    private static let herz = puzzle(title: "Herz", [
        "...............",
        "...XXX...XXX...",
        "..XXXXX.XXXXX..",
        ".XXXXXXXXXXXXX.",
        ".XXXXXXXXXXXXX.",
        ".XXXXXXXXXXXXX.",
        "..XXXXXXXXXXX..",
        "...XXXXXXXXX...",
        "....XXXXXXX....",
        ".....XXXXX.....",
        "......XXX......",
        ".......X.......",
        "...............",
        "...............",
        "...............",
    ])

    private static let baum = puzzle(title: "Weihnachtsbaum", [
        ".......X.......",
        "......XXX......",
        ".....XXXXX.....",
        "....XXXXXXX....",
        "...XXXXXXXXX...",
        "..XXXXXXXXXXX..",
        ".XXXXXXXXXXXXX.",
        "XXXXXXXXXXXXXXX",
        "......XXX......",
        "......XXX......",
        "......XXX......",
        "...............",
        "...............",
        "...............",
        "...............",
    ])

    private static let haus = puzzle(title: "Haus", [
        ".......X.......",
        "......XXX......",
        ".....XXXXX.....",
        "....XXXXXXX....",
        "...XXXXXXXXX...",
        "..XXXXXXXXXXX..",
        "..XXXXXXXXXXX..",
        "..XX.XXXXX.XX..",
        "..XX.XXXXX.XX..",
        "..XXXXXXXXXXX..",
        "..XXXX...XXXX..",
        "..XXXX...XXXX..",
        "..XXXXXXXXXXX..",
        "...............",
        "...............",
    ])

    private static let fisch = puzzle(title: "Fisch", [
        "...............",
        "...............",
        "XX.............",
        "XXXX...........",
        "XXXXXXXXXX.....",
        "XXXXXXXXXXXXXX.",
        "XXXXXXXXXXXXXX.",
        "XXXXXXXXXXXXXX.",
        "XXXXXXXXXX.....",
        "XXXX...........",
        "XX.............",
        "...............",
        "...............",
        "...............",
        "...............",
    ])

    private static let katze = puzzle(title: "Katze", [
        "...............",
        ".XXX.......XXX.",
        ".XXXXX...XXXXX.",
        "..XXXXXXXXXXX..",
        ".XXXXXXXXXXXXX.",
        ".XXXXXXXXXXXXX.",
        ".XXX.XXXXX.XXX.",
        ".XXX.XXXXX.XXX.",
        ".XXXXXXXXXXXXX.",
        ".XXXXX.X.XXXXX.",
        ".XXXX.XXX.XXXX.",
        ".XXXXXXXXXXXXX.",
        "..XXXXXXXXXXX..",
        "...............",
        "...............",
    ])

    private static let rakete = puzzle(title: "Rakete", [
        ".......X.......",
        "......XXX......",
        ".....XXXXX.....",
        ".....XXXXX.....",
        "....XXXXXXX....",
        "....XXXXXXX....",
        "....XXXXXXX....",
        "....XXXXXXX....",
        "....XXXXXXX....",
        "...XXXXXXXXX...",
        ".X..XXXXXXX..X.",
        ".X..XXXXXXX..X.",
        "...XXXXXXXXX...",
        "....XXXXXXX....",
        ".......X.......",
    ])

    private static let pilz = puzzle(title: "Pilz", [
        "....XXXXXXX....",
        "..XXXXXXXXXXX..",
        ".XXXXX.X.XXXXX.",
        ".XXXXX.X.XXXXX.",
        "XXXXXXXXXXXXXXX",
        "XXXXXXXXXXXXXXX",
        "...XXXXXXXXX...",
        "...XXXXXXXXX...",
        "...XXXXXXXXX...",
        "..XXXXXXXXXXX..",
        "..XXXXXXXXXXX..",
        "...............",
        "...............",
        "...............",
        "...............",
    ])

    private static let sonne = puzzle(title: "Sonne", [
        ".......X.......",
        "..X....X....X..",
        "...X...X...X...",
        "....XXXXXXX....",
        "...XXXXXXXXX...",
        "..XXXXXXXXXXX..",
        "XXXXXXXXXXXXXXX",
        "..XXXXXXXXXXX..",
        "...XXXXXXXXX...",
        "....XXXXXXX....",
        "...X...X...X...",
        "..X....X....X..",
        ".......X.......",
        "...............",
        "...............",
    ])

    private static let vogel = puzzle(title: "Vogel", [
        "...............",
        ".X...........X.",
        "XXX.........XXX",
        ".XXXXXXXXXXXXX.",
        "..XXXXXXXXXXX..",
        "...XXXXXXXXX...",
        "....XXXXXXX....",
        ".....XXXXX.....",
        "......XXX......",
        ".......X.......",
        "...............",
        "...............",
        "...............",
        "...............",
        "...............",
    ])

    private static let diamant = puzzle(title: "Diamant", [
        ".......X.......",
        "......XXX......",
        ".....XXXXX.....",
        "....XXXXXXX....",
        "...XXXXXXXXX...",
        "..XXXXXXXXXXX..",
        ".XXXXXXXXXXXXX.",
        "..XXXXXXXXXXX..",
        "...XXXXXXXXX...",
        "....XXXXXXX....",
        ".....XXXXX.....",
        "......XXX......",
        ".......X.......",
        "...............",
        "...............",
    ])
}
