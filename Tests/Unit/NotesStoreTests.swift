import XCTest
import SwiftData
@testable import App

@MainActor
final class NotesStoreTests: XCTestCase {
    private var container: ModelContainer!
    private var store: NotesStore!

    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Note.self, configurations: config)
        store = NotesStore(context: ModelContext(container))
    }

    override func tearDownWithError() throws {
        store = nil
        container = nil
    }

    func testCreateThenFetch() throws {
        store.create(text: "Trail mix")
        let notes = try store.allNotes()
        XCTAssertEqual(notes.count, 1)
        XCTAssertEqual(notes.first?.displayTitle, "Trail mix")
    }

    func testUpdateBumpsTimestamp() throws {
        let note = store.create(text: "First", now: Date(timeIntervalSince1970: 0))
        let before = note.updatedAt
        store.update(note, text: "Second", now: Date(timeIntervalSince1970: 100))
        XCTAssertGreaterThan(note.updatedAt, before)
        XCTAssertEqual(note.text, "Second")
    }

    func testUnchangedUpdateIsANoOp() {
        let note = store.create(text: "Same", now: Date(timeIntervalSince1970: 0))
        let before = note.updatedAt
        store.update(note, text: "Same", now: Date(timeIntervalSince1970: 500))
        XCTAssertEqual(note.updatedAt, before)
    }

    func testPinAndUnpin() {
        let note = store.create(text: "Pin me")
        store.setPinned(note, true)
        XCTAssertTrue(note.isPinned)
        store.setPinned(note, false)
        XCTAssertFalse(note.isPinned)
    }

    func testDeleteThenRestoreKeepsIdentity() throws {
        let note = store.create(text: "Delete me")
        store.setPinned(note, true)
        let id = note.id
        let created = note.createdAt

        let snapshot = store.delete(note)
        XCTAssertEqual(try store.allNotes().count, 0)

        store.restore(snapshot)
        let restored = try XCTUnwrap(try store.allNotes().first)
        XCTAssertEqual(restored.id, id)
        XCTAssertEqual(restored.text, "Delete me")
        XCTAssertEqual(restored.createdAt, created)
        XCTAssertTrue(restored.isPinned)
    }

    func testDiscardIfEmptyDropsBlankNotesOnly() throws {
        let blank = store.create(text: "   \n ")
        let real = store.create(text: "Real")
        XCTAssertTrue(store.discardIfEmpty(blank))
        XCTAssertFalse(store.discardIfEmpty(real))
        XCTAssertEqual(try store.allNotes().count, 1)
    }

    func testNotesSortNewestFirst() throws {
        store.create(text: "Older", now: Date(timeIntervalSince1970: 10))
        store.create(text: "Newer", now: Date(timeIntervalSince1970: 200))
        XCTAssertEqual(try store.allNotes().first?.displayTitle, "Newer")
    }

    /// The persistence half of the functionality rule: write, drop the
    /// container, rebuild from the same file, and the note is still there.
    func testNotesSurviveContainerReload() throws {
        let url = URL.temporaryDirectory.appending(path: "slate-test-\(UUID().uuidString).store")
        defer { try? FileManager.default.removeItem(at: url) }

        let config = ModelConfiguration(url: url)
        var diskContainer: ModelContainer? = try ModelContainer(for: Note.self, configurations: config)
        var diskStore: NotesStore? = NotesStore(context: ModelContext(diskContainer!))
        diskStore?.create(text: "Survives relaunch")
        diskStore = nil
        diskContainer = nil

        let reopened = try ModelContainer(for: Note.self, configurations: ModelConfiguration(url: url))
        let reopenedStore = NotesStore(context: ModelContext(reopened))
        let notes = try reopenedStore.allNotes()
        XCTAssertEqual(notes.count, 1)
        XCTAssertEqual(notes.first?.displayTitle, "Survives relaunch")
    }
}
