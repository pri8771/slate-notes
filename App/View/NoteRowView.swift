import SwiftUI

struct NoteRowView: View {
    let note: Note
    let isLast: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: DS.Space.xs) {
                Text(note.displayTitle)
                    .font(DS.Font.rowTitle)
                    .foregroundStyle(DS.Color.ink)
                    .lineLimit(1)
                    .accessibilityIdentifier("note.row.title.\(note.id.uuidString)")
                HStack(spacing: DS.Space.s) {
                    Text(NoteDate.rowLabel(for: note.updatedAt))
                        .foregroundStyle(DS.Color.secondary)
                    Text(note.displaySnippet)
                        .foregroundStyle(DS.Color.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .font(DS.Font.rowMeta)
            }
            .padding(.vertical, DS.Metric.rowVerticalPadding)

            if !isLast {
                Rectangle()
                    .fill(DS.Color.hairline)
                    .frame(height: DS.Metric.hairline)
            }
        }
        .contentShape(Rectangle())
        .accessibilityIdentifier("note.row.\(note.id.uuidString)")
    }
}

struct SearchResultRow: View {
    let result: SearchResult
    let isLast: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: DS.Space.xs) {
                Text(result.title)
                    .font(DS.Font.rowTitle)
                    .foregroundStyle(DS.Color.ink)
                    .lineLimit(1)
                Text(highlighted)
                    .font(DS.Font.rowMeta)
                    .foregroundStyle(DS.Color.secondary)
                    .lineLimit(1)
            }
            .padding(.vertical, DS.Metric.rowVerticalPadding)

            if !isLast {
                Rectangle()
                    .fill(DS.Color.hairline)
                    .frame(height: DS.Metric.hairline)
            }
        }
        .contentShape(Rectangle())
        .accessibilityIdentifier("search.result.\(result.id.uuidString)")
    }

    /// Paints the matched range with the highlight token.
    private var highlighted: AttributedString {
        var attributed = AttributedString(result.snippet)
        if let range = Range(result.highlight, in: attributed) {
            attributed[range].backgroundColor = DS.Color.searchHighlight
            attributed[range].foregroundColor = DS.Color.ink
        }
        return attributed
    }
}
