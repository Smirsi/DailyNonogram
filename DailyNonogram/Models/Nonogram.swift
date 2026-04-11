import Foundation

struct Nonogram {
    let title: String
    let rows: Int
    let cols: Int
    let rowClues: [[Int]]
    let colClues: [[Int]]
    let solution: [[Bool]]

    static func computeClues(from grid: [[Bool]]) -> (rows: [[Int]], cols: [[Int]]) {
        let numRows = grid.count
        let numCols = grid[0].count

        let rowClues = (0..<numRows).map { row -> [Int] in
            var clue: [Int] = []
            var count = 0
            for col in 0..<numCols {
                if grid[row][col] { count += 1 }
                else if count > 0 { clue.append(count); count = 0 }
            }
            if count > 0 { clue.append(count) }
            return clue.isEmpty ? [0] : clue
        }

        let colClues = (0..<numCols).map { col -> [Int] in
            var clue: [Int] = []
            var count = 0
            for row in 0..<numRows {
                if grid[row][col] { count += 1 }
                else if count > 0 { clue.append(count); count = 0 }
            }
            if count > 0 { clue.append(count) }
            return clue.isEmpty ? [0] : clue
        }

        return (rowClues, colClues)
    }
}
