import XCTest
@testable import App

final class NoteSearchTests: XCTestCase {

    private let notes = [
        SearchableNote(id: UUID(), title: "Trail mix recipe",
                       body: "Toast the almonds first — ten minutes at 160 degrees, shake the tray halfway through baking."),
        SearchableNote(id: UUID(), title: "Gift ideas",
                       body: "Ceramic pour-over, that linen apron, the almond croissants from the café for Amma."),
        SearchableNote(id: UUID(), title: "Reading list", body: "Salt Fat Acid Heat")
    ]

    func testFindsMatchesCaseInsensitively() {
        XCTAssertEqual(NoteSearch.results(for: "ALMOND", in: notes).count, 2)
    }

    func testMatchesIgnoreDiacritics() {
        XCTAssertEqual(NoteSearch.results(for: "cafe", in: notes).count, 1)
    }

    func testEmptyQueryReturnsNothing() {
        XCTAssertTrue(NoteSearch.results(for: "", in: notes).isEmpty)
        XCTAssertTrue(NoteSearch.results(for: "   ", in: notes).isEmpty)
    }

    func testNoMatchReturnsNothing() {
        XCTAssertTrue(NoteSearch.results(for: "zebra", in: notes).isEmpty)
    }

    func testHighlightRangeCoversTheMatch() throws {
        let result = try XCTUnwrap(NoteSearch.results(for: "almonds", in: notes).first)
        XCTAssertEqual(result.snippet[result.highlight].lowercased(), "almonds")
    }

    func testMatchAtStartHasNoLeadingEllipsis() {
        let note = SearchableNote(id: UUID(), title: "Almond butter", body: "for toast")
        let result = NoteSearch.results(for: "almond", in: [note]).first
        XCTAssertEqual(result?.snippet.hasPrefix("…"), false)
    }

    func testShortNoteIsNotTruncated() {
        let note = SearchableNote(id: UUID(), title: "Heat", body: "Salt Fat Acid")
        let result = NoteSearch.results(for: "salt", in: [note]).first
        XCTAssertEqual(result?.snippet.hasSuffix("…"), false)
    }

    func testMultilineBodyCollapsesToOneLine() {
        let note = SearchableNote(id: UUID(), title: "List", body: "one\ntwo\nthree almond")
        let result = NoteSearch.results(for: "almond", in: [note]).first
        XCTAssertEqual(result?.snippet.contains("\n"), false)
    }
}
