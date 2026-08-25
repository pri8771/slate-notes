import XCTest
@testable import App

final class NoteDateTests: XCTestCase {
    private var calendar = Calendar(identifier: .gregorian)

    private func date(_ iso: String) -> Date {
        let f = ISO8601DateFormatter()
        f.timeZone = calendar.timeZone
        return f.date(from: iso)!
    }

    func testTodayShowsTime() {
        let now = date("2026-08-24T14:00:00Z")
        let label = NoteDate.rowLabel(for: now, relativeTo: now, calendar: calendar)
        XCTAssertFalse(label.contains("/"), "today should render a time, got \(label)")
    }

    func testYesterdayIsNamed() {
        let now = date("2026-08-24T14:00:00Z")
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
        XCTAssertEqual(NoteDate.rowLabel(for: yesterday, relativeTo: now, calendar: calendar),
                       "Yesterday")
    }

    func testWithinWeekShowsWeekday() {
        let now = date("2026-08-24T14:00:00Z")
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: now)!
        let label = NoteDate.rowLabel(for: threeDaysAgo, relativeTo: now, calendar: calendar)
        XCTAssertFalse(label.contains("/"), "within a week should be a weekday, got \(label)")
        XCTAssertNotEqual(label, "Yesterday")
    }

    func testOlderShowsNumericDate() {
        let now = date("2026-08-24T14:00:00Z")
        let old = calendar.date(byAdding: .day, value: -30, to: now)!
        let label = NoteDate.rowLabel(for: old, relativeTo: now, calendar: calendar)
        XCTAssertTrue(label.contains("/"), "old dates should be numeric, got \(label)")
    }

    func testEditorHeaderJoinsDateAndTime() {
        XCTAssertTrue(NoteDate.editorHeader(for: date("2026-08-24T14:00:00Z")).contains("·"))
    }
}
