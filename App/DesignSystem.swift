import SwiftUI

// The only place colors, fonts, and spacing are defined. Every view styles
// through these tokens; inline values elsewhere are a rule violation.
enum DS {
    enum Color {
        static let accent = SwiftUI.Color.accentColor
        static let background = SwiftUI.Color(.systemBackground)
        static let surface = SwiftUI.Color(.secondarySystemBackground)
        static let textPrimary = SwiftUI.Color.primary
        static let textSecondary = SwiftUI.Color.secondary
        static let destructive = SwiftUI.Color.red
    }

    enum Font {
        static let title = SwiftUI.Font.title2.weight(.semibold)
        static let body = SwiftUI.Font.body
        static let caption = SwiftUI.Font.caption
    }

    enum Space {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
        static let xl: CGFloat = 40
    }
}
