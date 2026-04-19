import SwiftUI

enum DS {

    // MARK: - Colors (adaptive light / dark)

    /// Main app background
    static let background    = adaptive(light: 0xF8F5F0, dark: 0x1C1814)
    /// Clue area, toolbar, card surfaces
    static let surface       = adaptive(light: 0xEFEBE4, dark: 0x252018)
    /// Filled cells
    static let filled        = adaptive(light: 0x1A1A1A, dark: 0xF0EDE8)
    /// Crossed/marker cell background
    static let crossed       = adaptive(light: 0xE8E4DF, dark: 0x2E2A26)
    /// X stroke color in manually crossed cells
    static let crossedMark   = adaptive(light: 0x8A8580, dark: 0x706B65)
    /// Thin grid lines
    static let gridLine      = adaptive(light: 0xD4CFC9, dark: 0x3A3530)
    /// Bold section dividers every 5 cells
    static let boldLine      = adaptive(light: 0xA8A39D, dark: 0x4A4540)
    /// Outer grid border
    static let border        = adaptive(light: 0x2C2A27, dark: 0xC0BDB8)
    /// Warm terracotta — accent / auto-cross / selected state (same in both modes)
    static let accent        = Color(red: 0.769, green: 0.443, blue: 0.290) // #C4714A
    /// Error cell background (wrongly filled, revealed by error-reveal feature)
    static let errorCell     = Color(red: 0.88, green: 0.28, blue: 0.28)
    /// Hinted cell background (revealed by hint — correct cell)
    static let hintedCell    = Color(red: 0.32, green: 0.68, blue: 0.42)
    /// Primary text
    static let textPrimary   = adaptive(light: 0x1A1A1A, dark: 0xF0EDE8)
    /// Secondary text
    static let textSecondary = adaptive(light: 0x8A8580, dark: 0x908B85)
    /// Tertiary text — dates, satisfied clues
    static let textTertiary  = adaptive(light: 0xB0ABA5, dark: 0x706B65)
    /// Hairline separator
    static let separator     = adaptive(light: 0xD4CFC9, dark: 0x3A3530)

    // MARK: - Helpers

    /// Creates a SwiftUI Color that automatically switches between light and dark mode.
    private static func adaptive(light: Int, dark: Int) -> Color {
        Color(UIColor(dynamicProvider: { tc in
            tc.userInterfaceStyle == .dark
                ? UIColor(hex: dark)
                : UIColor(hex: light)
        }))
    }

    // MARK: - Typography

    static func titleFont() -> Font {
        .custom("Georgia", size: 22).weight(.semibold)
    }

    static func dateLabelFont() -> Font {
        .system(size: 13, weight: .regular)
    }

    static func clueFont() -> Font {
        .system(size: 11, weight: .medium, design: .monospaced)
    }

    static func toolLabelFont() -> Font {
        .system(size: 11, weight: .medium)
    }

    static func completionHeadlineFont() -> Font {
        .custom("Georgia", size: 28).weight(.semibold)
    }

    // MARK: - Geometry

    /// Subtle corner radius on the outer grid border
    static let outerBorderRadius: CGFloat = 4
    /// Completion card corner radius
    static let completionRadius: CGFloat  = 24
}

// MARK: - UIColor Hex Initializer

private extension UIColor {
    convenience init(hex: Int) {
        let r = CGFloat((hex >> 16) & 0xFF) / 255
        let g = CGFloat((hex >> 8)  & 0xFF) / 255
        let b = CGFloat( hex        & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
