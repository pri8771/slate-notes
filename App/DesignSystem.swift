import SwiftUI
import UIKit

// The only place colors, fonts, spacing, and metrics are defined. Every view
// styles through these tokens; inline values elsewhere are a rule violation.
// Values come from the approved design boards in design/ (light → dark).
enum DS {

    enum Color {
        /// Page ground: warm paper in light, near-black in dark.
        static let ground = SwiftUI.Color(light: 0xF7F6F3, dark: 0x161618)
        /// Primary text.
        static let ink = SwiftUI.Color(light: 0x1A1A1C, dark: 0xEDEDEF)
        /// Meta text, snippets, icon strokes, section headers.
        static let secondary = SwiftUI.Color(light: 0x7A7A80, dark: 0x98989F)
        /// Reserved for actions: FAB, Done, Cancel, links, caret.
        static let accent = SwiftUI.Color(light: 0x4E5D78, dark: 0x8FA3C8)
        /// Raised surfaces: search pill, undo toast.
        static let surface = SwiftUI.Color(light: 0xECEAE5, dark: 0x232326)
        /// Hairline separators between rows.
        static let hairline = SwiftUI.Color(light: 0xE4E2DD, dark: 0x2A2A2E)
        /// Search match background. Dark value is the slate twin of the light wash.
        static let searchHighlight = SwiftUI.Color(light: 0xDEE4EF, dark: 0x2E3A52)
        /// Empty-state glyph stroke.
        static let emptyGlyph = SwiftUI.Color(light: 0xC9C6BE, dark: 0x3A3A3F)
        /// Glyph drawn inside the accent FAB.
        static let fabGlyph = SwiftUI.Color(light: 0xFFFFFF, dark: 0x161618)
        /// Destructive actions — a muted brick, not system red, for this palette.
        static let destructive = SwiftUI.Color(light: 0xC0483C, dark: 0xE2695C)
    }

    enum Font {
        static let screenTitle = SwiftUI.Font.system(size: 34, weight: .bold)
        static let sectionHeader = SwiftUI.Font.system(size: 12, weight: .semibold)
        static let rowTitle = SwiftUI.Font.system(size: 16, weight: .semibold)
        static let rowMeta = SwiftUI.Font.system(size: 14)
        static let searchField = SwiftUI.Font.system(size: 16)
        static let navAction = SwiftUI.Font.system(size: 17)
        static let navActionStrong = SwiftUI.Font.system(size: 17, weight: .semibold)
        static let editorTitle = SwiftUI.Font.system(size: 26, weight: .bold)
        static let editorBody = SwiftUI.Font.system(size: 17)
        static let dateHeader = SwiftUI.Font.system(size: 12)
        static let footer = SwiftUI.Font.system(size: 12)
        static let emptyTitle = SwiftUI.Font.system(size: 20, weight: .semibold)
        static let emptyBody = SwiftUI.Font.system(size: 15)
    }

    enum Space {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
        static let xl: CGFloat = 40
        /// Standard screen side padding.
        static let gutter: CGFloat = 20
        /// Editor side padding (wider, for reading).
        static let editorGutter: CGFloat = 24
    }

    enum Metric {
        static let pillRadius: CGFloat = 10
        static let fabSize: CGFloat = 54
        static let fabTrailing: CGFloat = 20
        static let fabBottom: CGFloat = 44
        static let hairline: CGFloat = 1
        static let emptyGlyph: CGFloat = 56
        static let highlightRadius: CGFloat = 3
        static let minTapTarget: CGFloat = 44
        /// 17pt body at the board's 1.55 line-height.
        static let editorLineSpacing: CGFloat = 9
        /// 0.06em tracking on the 12pt section headers.
        static let sectionTracking: CGFloat = 0.72
        static let rowVerticalPadding: CGFloat = 12
        static let footerBottom: CGFloat = 28
    }

    enum Shadow {
        static let fabRadius: CGFloat = 8
        static let fabY: CGFloat = 6
        static var fabColor: SwiftUI.Color {
            SwiftUI.Color(light: 0x1E283C, dark: 0x000000, lightAlpha: 0.25, darkAlpha: 0.5)
        }
    }
}

private extension SwiftUI.Color {
    /// Builds a dynamic color from two hex values so light and dark are always
    /// defined together — a light-only literal cannot slip in.
    init(light: UInt32, dark: UInt32, lightAlpha: CGFloat = 1, darkAlpha: CGFloat = 1) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(hex: dark, alpha: darkAlpha)
                : UIColor(hex: light, alpha: lightAlpha)
        })
    }
}

private extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: alpha
        )
    }
}
