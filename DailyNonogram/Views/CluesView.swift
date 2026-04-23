import SwiftUI

// MARK: - Row Clues (left side, vertical stack)

struct RowCluesView: View {
    let clues: [[Int]]
    let cellSize: CGFloat
    var checkedClues: [[Bool]] = []
    var alignRight: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            ForEach(clues.indices, id: \.self) { row in
                HStack(spacing: 4) {
                    if alignRight { Spacer(minLength: 0) }
                    ForEach(clues[row].indices, id: \.self) { i in
                        let isChecked = checkedClues.indices.contains(row)
                            && checkedClues[row].indices.contains(i)
                            && checkedClues[row][i]
                        Text("\(clues[row][i])")
                            .font(DS.clueFontScaled(cellSize: cellSize))
                            .foregroundStyle(isChecked ? DS.textTertiary : DS.textPrimary)
                            .strikethrough(isChecked, color: DS.textTertiary)
                    }
                    if !alignRight { Spacer(minLength: 0) }
                }
                .frame(height: cellSize)
            }
        }
    }
}

// MARK: - Column Clues (top, horizontal stack)

struct ColCluesView: View {
    let clues: [[Int]]
    let cellSize: CGFloat
    var checkedClues: [[Bool]] = []
    var alignBottom: Bool = true

    var body: some View {
        HStack(spacing: 0) {
            ForEach(clues.indices, id: \.self) { col in
                VStack(spacing: 4) {
                    if alignBottom { Spacer(minLength: 0) }
                    ForEach(clues[col].indices, id: \.self) { i in
                        let isChecked = checkedClues.indices.contains(col)
                            && checkedClues[col].indices.contains(i)
                            && checkedClues[col][i]
                        Text("\(clues[col][i])")
                            .font(DS.clueFontScaled(cellSize: cellSize))
                            .foregroundStyle(isChecked ? DS.textTertiary : DS.textPrimary)
                            .strikethrough(isChecked, color: DS.textTertiary)
                    }
                    if !alignBottom { Spacer(minLength: 0) }
                }
                .frame(width: cellSize)
            }
        }
    }
}
