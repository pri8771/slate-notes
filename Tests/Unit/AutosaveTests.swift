import XCTest
@testable import App

@MainActor
final class AutosaveTests: XCTestCase {

    func testRapidSchedulesFireOnce() async throws {
        var fires = 0
        let autosave = Autosave(interval: .milliseconds(50)) { fires += 1 }
        autosave.schedule()
        autosave.schedule()
        autosave.schedule()
        try await Task.sleep(for: .milliseconds(200))
        XCTAssertEqual(fires, 1)
    }

    func testFlushFiresImmediatelyAndCancelsPending() async throws {
        var fires = 0
        let autosave = Autosave(interval: .milliseconds(200)) { fires += 1 }
        autosave.schedule()
        autosave.flush()
        XCTAssertEqual(fires, 1)
        try await Task.sleep(for: .milliseconds(300))
        XCTAssertEqual(fires, 1, "the cancelled scheduled fire must not run")
    }
}
