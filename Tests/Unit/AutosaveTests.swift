import XCTest
@testable import App

final class AutosaveTests: XCTestCase {

    @MainActor
    func testRapidSchedulesFireOnce() async throws {
        var fires = 0
        let autosave = Autosave(interval: .milliseconds(50)) { fires += 1 }
        autosave.schedule()
        autosave.schedule()
        autosave.schedule()
        try await Task.sleep(for: .milliseconds(200))
        XCTAssertEqual(fires, 1)
    }

    @MainActor
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
