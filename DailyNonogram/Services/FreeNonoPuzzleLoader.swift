import Foundation
import SwiftUI

/// Loads B&W puzzles from FreeNono `.nonogram` XML files bundled in the app.
struct FreeNonoPuzzleLoader {

    static func load(difficulty: DifficultyLevel) -> [Nonogram] {
        guard let urls = Bundle.main.urls(
            forResourcesWithExtension: "nonogram",
            subdirectory: "Puzzles/\(difficulty.subdirectory)"
        ) else {
            return []
        }
        return urls
            .compactMap { load(from: $0, difficulty: difficulty) }
            .sorted { $0.title < $1.title }
    }

    static func load(from url: URL, difficulty: DifficultyLevel = .easy) -> Nonogram? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        let parser = NonogramXMLParser(data: data, difficulty: difficulty)
        return parser.parse()
    }
}

// MARK: - Color Nonogram Loader

/// Loads color puzzles from `.cnonogram` XML files.
struct ColorNonogramLoader {

    static func load(difficulty: DifficultyLevel) -> [Nonogram] {
        guard let urls = Bundle.main.urls(
            forResourcesWithExtension: "cnonogram",
            subdirectory: "Puzzles/\(difficulty.subdirectory)"
        ) else {
            return []
        }
        return urls
            .compactMap { load(from: $0, difficulty: difficulty) }
            .sorted { $0.title < $1.title }
    }

    static func load(from url: URL, difficulty: DifficultyLevel = .colorEasy) -> Nonogram? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        let parser = ColorNonogramXMLParser(data: data, difficulty: difficulty)
        return parser.parse()
    }
}

// MARK: - B&W XML Parser

private final class NonogramXMLParser: NSObject, XMLParserDelegate {
    private let data: Data
    private let difficulty: DifficultyLevel

    private var name: String = ""
    private var rows: [[Bool]] = []
    private var currentText = ""
    private var insideNonogram = false

    init(data: Data, difficulty: DifficultyLevel) {
        self.data = data
        self.difficulty = difficulty
    }

    func parse() -> Nonogram? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        guard parser.parse(), !rows.isEmpty, let firstRow = rows.first, !firstRow.isEmpty else {
            return nil
        }
        let cols = firstRow.count
        let grid = rows.filter { $0.count == cols }
        guard !grid.isEmpty else { return nil }

        let clues = Nonogram.computeClues(from: grid)
        let cleaned = name.replacingOccurrences(of: #"(?i)\s+[vh]flip$"#, with: "", options: .regularExpression)
        let title = cleaned.isEmpty ? "Unbekannt" : cleaned.capitalized
        return Nonogram(
            title: title,
            rows: grid.count,
            cols: cols,
            rowClues: clues.rows,
            colClues: clues.cols,
            solution: grid,
            difficulty: difficulty
        )
    }

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes: [String: String] = [:]) {
        if elementName == "Nonogram" {
            name = attributes["name"] ?? ""
            rows = []
            insideNonogram = true
        } else if elementName == "line" {
            currentText = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentText += string
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == "line" && insideNonogram {
            let row = currentText
                .split(separator: " ", omittingEmptySubsequences: true)
                .map { $0 == "x" }
            if !row.isEmpty {
                rows.append(row)
            }
        } else if elementName == "Nonogram" {
            insideNonogram = false
        }
    }
}

// MARK: - Color XML Parser

private final class ColorNonogramXMLParser: NSObject, XMLParserDelegate {
    private let data: Data
    private let difficulty: DifficultyLevel

    private var name: String = ""
    private var colorRows: [[Int]] = []
    private var palette: [Int: Color] = [:]
    private var currentText = ""
    private var insideNonogram = false
    private var insidePalette = false

    init(data: Data, difficulty: DifficultyLevel) {
        self.data = data
        self.difficulty = difficulty
    }

    func parse() -> Nonogram? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        guard parser.parse(), !colorRows.isEmpty, let firstRow = colorRows.first, !firstRow.isEmpty else {
            return nil
        }
        let cols = firstRow.count
        let grid = colorRows.filter { $0.count == cols }
        guard !grid.isEmpty else { return nil }

        let rows = grid.count
        let boolGrid = grid.map { $0.map { $0 > 0 } }
        let clues = Nonogram.computeClues(from: boolGrid)

        let rowColorClues = computeColorClues(grid: grid, lineCount: rows, cellCount: cols, byRow: true)
        let colColorClues = computeColorClues(grid: grid, lineCount: cols, cellCount: rows, byRow: false)

        let cleaned = name.replacingOccurrences(of: #"(?i)\s+[vh]flip$"#, with: "", options: .regularExpression)
        let title = cleaned.isEmpty ? "Unbekannt" : cleaned.capitalized
        var nono = Nonogram(
            title: title,
            rows: rows,
            cols: cols,
            rowClues: clues.rows,
            colClues: clues.cols,
            solution: boolGrid,
            difficulty: difficulty,
            isColorized: true
        )
        nono.colorSolution = grid
        nono.colorPalette = palette
        nono.colorClueRows = rowColorClues
        nono.colorClueCols = colColorClues
        return nono
    }

    private func computeColorClues(grid: [[Int]], lineCount: Int, cellCount: Int, byRow: Bool)
        -> [[(color: Int, length: Int)]] {
        var result: [[(color: Int, length: Int)]] = []
        for i in 0..<lineCount {
            var clue: [(color: Int, length: Int)] = []
            var prev = 0, count = 0
            for j in 0..<cellCount {
                let v = byRow ? grid[i][j] : grid[j][i]
                if v == 0 {
                    if count > 0 && prev > 0 { clue.append((color: prev, length: count)) }
                    prev = 0; count = 0
                } else if v == prev {
                    count += 1
                } else {
                    if count > 0 && prev > 0 { clue.append((color: prev, length: count)) }
                    prev = v; count = 1
                }
            }
            if count > 0 && prev > 0 { clue.append((color: prev, length: count)) }
            result.append(clue)
        }
        return result
    }

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes: [String: String] = [:]) {
        if elementName == "Nonogram" {
            name = attributes["name"] ?? ""
            colorRows = []
            palette = [:]
            insideNonogram = true
        } else if elementName == "palette" {
            insidePalette = true
        } else if elementName == "color" && insidePalette {
            if let idxStr = attributes["index"], let idx = Int(idxStr),
               let hex = attributes["hex"],
               let color = Color(hex: hex) {
                palette[idx] = color
            }
        } else if elementName == "line" {
            currentText = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentText += string
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == "palette" {
            insidePalette = false
        } else if elementName == "line" && insideNonogram {
            let row = currentText
                .split(separator: " ", omittingEmptySubsequences: true)
                .compactMap { Int($0) }
            if !row.isEmpty {
                colorRows.append(row)
            }
        } else if elementName == "Nonogram" {
            insideNonogram = false
        }
    }
}
