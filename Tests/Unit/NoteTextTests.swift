import XCTest
@testable import App

final class NoteTextTests: XCTestCase {

    func testTitleIsFirstNonBlankLine() {
        XCTAssertEqual(NoteText.title(from: "Trail mix\nAlmonds"), "Trail mix")
        XCTAssertEqual(NoteText.title(from: "\n\n  Gift ideas  \nmore"), "Gift ideas")
    }

    func testTitleFallsBackWhenBlank() {
        XCTAssertEqual(NoteText.title(from: "   \n\n "), NoteText.untitled)
        XCTAssertEqual(NoteText.title(from: ""), NoteText.untitled)
    }

    func testSnippetSkipsTitleAndCollapsesWhitespace() {
        let text = "Trail mix\nAlmonds,\n\n  dried   mango"
        XCTAssertEqual(NoteText.snippet(from: text), "Almonds, dried mango")
    }

    func testSnippetFallsBackWithoutBody() {
        XCTAssertEqual(NoteText.snippet(from: "Only a title"), NoteText.emptySnippet)
    }

    func testCountLabelPluralizes() {
        XCTAssertEqual(NoteText.countLabel(0), "0 notes")
        XCTAssertEqual(NoteText.countLabel(1), "1 note")
        XCTAssertEqual(NoteText.countLabel(6), "6 notes")
    }
}
