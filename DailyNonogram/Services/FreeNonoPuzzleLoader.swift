import Foundation

/// Loads puzzles from FreeNono `.nonogram` XML files bundled in the app.
///
/// Files are organised in subdirectories per difficulty:
/// `Puzzles/easy/`, `Puzzles/medium/`, `Puzzles/hard/`
///
/// Expected XML format:
/// ```xml
/// <FreeNono><Nonograms>
///   <Nonogram name="seal" height="15" width="15">
///     <line> x _ x _ _ … </line>
///     …
///   </Nonogram>
/// </Nonograms></FreeNono>
/// ```
/// `x` = filled cell, `_` = empty cell.
struct FreeNonoPuzzleLoader {

    /// Loads all puzzles for a given difficulty level.
    static func load(difficulty: DifficultyLevel) -> [Nonogram] {
        // With a folder reference the bundle path is "Puzzles/<level>"
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

    /// Parses a single `.nonogram` file and returns a `Nonogram`, or `nil` on failure.
    static func load(from url: URL, difficulty: DifficultyLevel = .easy) -> Nonogram? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        let parser = NonogramXMLParser(data: data, difficulty: difficulty)
        return parser.parse()
    }
}

// MARK: - XML Parser

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
        let title = name.isEmpty ? "Unbekannt" : name.capitalized
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

    // MARK: XMLParserDelegate

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
