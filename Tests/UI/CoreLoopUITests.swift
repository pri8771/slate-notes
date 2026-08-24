import XCTest

final class CoreLoopUITests: XCTestCase {
    // Grows into the core-loop flow test. From day one it proves the app
    // launches to a real screen (part of the functionality rule).
    func testAppLaunchesToHome() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["home.title"].waitForExistence(timeout: 10))
    }
}
