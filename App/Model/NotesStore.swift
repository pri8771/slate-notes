import Foundation
import SwiftData

/// The write path. `@Query` is the read path; this type is the only one that
/// touches a ModelContext.
@MainActor
final class NotesStore {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    @discardableResult
    func create(text: String = "", now: Date = Date()) -> Note {
        let note = Note(text: text, createdAt: now, updatedAt: now)
        context.insert(note)
        save()
        return note
    }

    /// No-op (and no `updatedAt` bump) when the text is unchanged.
    func update(_ note: Note, text: String, now: Date = Date()) {
        guard note.text != text else { return }
        note.text = text
        note.updatedAt = now
        save()
    }

    func setPinned(_ note: Note, _ pinned: Bool) {
        guard note.isPinned != pinned else { return }
        note.isPinned = pinned
        save()
    }

    /// Hard delete, returning a snapshot so the UI can offer undo.
    @discardableResult
    func delete(_ note: Note) -> NoteSnapshot {
        let snapshot = NoteSnapshot(note)
        context.delete(note)
        save()
        return snapshot
    }

    /// Reinserts a deleted note with its original identity and timestamps.
    func restore(_ snapshot: NoteSnapshot) {
        let note = Note(
            id: snapshot.id,
            text: snapshot.text,
            createdAt: snapshot.createdAt,
            updatedAt: snapshot.updatedAt,
            isPinned: snapshot.isPinned
        )
        context.insert(note)
        save()
    }

    /// Drops a note that was created but never written to.
    @discardableResult
    func discardIfEmpty(_ note: Note) -> Bool {
        guard note.isBlank else { return false }
        context.delete(note)
        save()
        return true
    }

    /// Most recently updated first. Used by tests and the search index.
    func allNotes() throws -> [Note] {
        try context.fetch(
            FetchDescriptor<Note>(sortBy: [SortDescriptor(\.updatedAt, order: .reverse)])
        )
    }

    func deleteAll() {
        guard let notes = try? allNotes() else { return }
        for note in notes { context.delete(note) }
        save()
    }

    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            // A failed save must never crash the app; the next mutation retries.
            assertionFailure("SwiftData save failed: \(error)")
        }
    }
}
