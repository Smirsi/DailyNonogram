import Foundation
import SwiftUI

struct ColorEntry: Codable, Sendable {
    let index: Int
    let hex: String

    var color: Color {
        Color(hex: hex) ?? .black
    }
}

struct Nonogram {
    let title: String
    let rows: Int
    let cols: Int
    let rowClues: [[Int]]
    let colClues: [[Int]]
    let solution: [[Bool]]
    var difficulty: DifficultyLevel = .easy
    var isColorized: Bool = false

    // Color-only fields (nil for B&W puzzles)
    var colorSolution: [[Int]]? = nil
    var colorPalette: [Int: Color]? = nil
    var colorClueRows: [[(color: Int, length: Int)]]? = nil
    var colorClueCols: [[(color: Int, length: Int)]]? = nil

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

// MARK: - Hex color initializer
extension Color {
    init?(hex: String) {
        var h = hex.trimmingCharacters(in: .whitespaces)
        if h.hasPrefix("#") { h = String(h.dropFirst()) }
        guard h.count == 6, let value = UInt64(h, radix: 16) else { return nil }
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
