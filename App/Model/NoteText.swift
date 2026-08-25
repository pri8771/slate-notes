import Foundation

/// Pure text derivations. No SwiftUI, no SwiftData — unit-testable directly.
enum NoteText {
    static let untitled = "New Note"
    static let emptySnippet = "No additional text"
    private static let titleLimit = 120

    /// First non-blank line, trimmed and length-capped.
    static func title(from text: String) -> String {
        for line in text.split(separator: "\n", omittingEmptySubsequences: false) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if !trimmed.isEmpty {
                return String(trimmed.prefix(titleLimit))
            }
        }
        return untitled
    }

    /// Everything after the title line, whitespace-collapsed to one line.
    static func snippet(from text: String) -> String {
        let lines = text.split(separator: "\n", omittingEmptySubsequences: false)
        guard let titleIndex = lines.firstIndex(where: {
            !$0.trimmingCharacters(in: .whitespaces).isEmpty
        }) else {
            return emptySnippet
        }
        let rest = lines[lines.index(after: titleIndex)...].joined(separator: " ")
        let collapsed = normalized(rest)
        return collapsed.isEmpty ? emptySnippet : collapsed
    }

    /// Collapses runs of whitespace (including newlines) into single spaces.
    static func normalized(_ text: String) -> String {
        text.split(whereSeparator: { $0.isWhitespace })
            .joined(separator: " ")
    }

    /// Footer label: "1 note" / "N notes".
    static func countLabel(_ count: Int) -> String {
        count == 1 ? "1 note" : "\(count) notes"
    }
}
