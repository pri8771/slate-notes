import Foundation

/// A note flattened for searching. Keeps search free of SwiftData.
struct SearchableNote: Identifiable, Equatable {
    let id: UUID
    let title: String
    let body: String
}

/// One hit: the snippet to show and the range inside it to highlight.
struct SearchResult: Identifiable, Equatable {
    let id: UUID
    let title: String
    let snippet: String
    let highlight: Range<String.Index>
}

/// Pure search over the queried array. Not `#Predicate`: iOS 17 predicates
/// handle localized contains poorly and cannot return the character ranges
/// highlighting needs. Linear scan is sub-millisecond at this scale.
enum NoteSearch {

    static func results(for query: String, in notes: [SearchableNote]) -> [SearchResult] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        return notes.compactMap { note in
            let haystack = NoteText.normalized(note.title + " " + note.body)
            guard let match = haystack.range(
                of: trimmed,
                options: [.caseInsensitive, .diacriticInsensitive],
                range: nil,
                locale: .current
            ) else { return nil }

            let (snippet, highlight) = self.snippet(around: match, in: haystack)
            return SearchResult(
                id: note.id,
                title: note.title,
                snippet: snippet,
                highlight: highlight
            )
        }
    }

    /// Windows the text around the match, snapping to word boundaries and
    /// adding ellipses only where text was actually cut.
    static func snippet(
        around match: Range<String.Index>,
        in text: String,
        lead: Int = 16,
        total: Int = 72
    ) -> (String, Range<String.Index>) {
        let matchStart = text.distance(from: text.startIndex, to: match.lowerBound)
        let matchLength = text.distance(from: match.lowerBound, to: match.upperBound)

        var startOffset = max(0, matchStart - lead)
        if startOffset > 0 {
            // Snap back to the start of the word we landed inside.
            var idx = text.index(text.startIndex, offsetBy: startOffset)
            while idx > text.startIndex, !text[text.index(before: idx)].isWhitespace {
                idx = text.index(before: idx)
            }
            startOffset = text.distance(from: text.startIndex, to: idx)
        }

        let available = max(total, matchLength)
        var endOffset = min(text.count, startOffset + available)
        if endOffset < text.count {
            var idx = text.index(text.startIndex, offsetBy: endOffset)
            while idx < text.endIndex, !text[idx].isWhitespace {
                idx = text.index(after: idx)
            }
            endOffset = text.distance(from: text.startIndex, to: idx)
        }
        endOffset = max(endOffset, matchStart + matchLength)

        let start = text.index(text.startIndex, offsetBy: startOffset)
        let end = text.index(text.startIndex, offsetBy: endOffset)
        let core = String(text[start..<end])

        let leadingEllipsis = startOffset > 0
        let trailingEllipsis = endOffset < text.count
        let composed = (leadingEllipsis ? "…" : "") + core + (trailingEllipsis ? "…" : "")

        // Re-locate the match inside the composed string.
        let prefixLength = leadingEllipsis ? 1 : 0
        let relativeStart = matchStart - startOffset + prefixLength
        let hStart = composed.index(composed.startIndex, offsetBy: relativeStart)
        let hEnd = composed.index(hStart, offsetBy: matchLength)
        return (composed, hStart..<hEnd)
    }
}
