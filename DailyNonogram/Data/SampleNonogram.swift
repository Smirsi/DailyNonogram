import Foundation

extension Nonogram {
    static let sample: Nonogram = Nonogram(
        title: "Pfeil",
        rows: 5,
        cols: 5,
        rowClues: [[1, 1], [5], [5], [3], [1]],
        colClues: [[2], [4], [4], [4], [2]],
        solution: [
            [false, true,  false, true,  false],
            [true,  true,  true,  true,  true ],
            [true,  true,  true,  true,  true ],
            [false, true,  true,  true,  false],
            [false, false, true,  false, false]
        ]
    )
}
