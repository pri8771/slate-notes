import Foundation
import SwiftData

/// A single note. The title is never stored — it is derived from the first
/// line of `text`, so the "first line is the title" rule cannot desync.
@Model
final class Note {
    var id: UUID
    var text: String
    var createdAt: Date
    var updatedAt: Date
    var isPinned: Bool

    init(
        id: UUID = UUID(),
        text: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isPinned: Bool = false
    ) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isPinned = isPinned
    }
}

extension Note {
    var displayTitle: String { NoteText.title(from: text) }
    var displaySnippet: String { NoteText.snippet(from: text) }
    var isBlank: Bool { text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
}

/// Value copy of a note, used to restore one after deletion.
struct NoteSnapshot: Equatable {
    let id: UUID
    let text: String
    let createdAt: Date
    let updatedAt: Date
    let isPinned: Bool

    init(_ note: Note) {
        id = note.id
        text = note.text
        createdAt = note.createdAt
        updatedAt = note.updatedAt
        isPinned = note.isPinned
    }
}
