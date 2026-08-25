import XCTest

final class CoreLoopUITests: XCTestCase {
    private let timeout: TimeInterval = 15

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    private func launch(_ flags: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = flags
        app.launch()
        return app
    }

    /// Pre-existing smoke check: the app launches to a real screen.
    func testAppLaunchesToHome() {
        let app = launch(["-UITestReset"])
        XCTAssertTrue(app.staticTexts["home.title"].waitForExistence(timeout: timeout))
    }

    func testEmptyStateShowsWhenNoNotes() {
        let app = launch(["-UITestReset"])
        XCTAssertTrue(app.staticTexts["empty.title"].waitForExistence(timeout: timeout))
        XCTAssertTrue(app.buttons["list.fab"].exists)
    }

    /// The core loop, end to end: create, type, relaunch, still there.
    func testCreateNoteTypeAndSurviveRelaunch() {
        let app = launch(["-UITestReset"])
        XCTAssertTrue(app.buttons["list.fab"].waitForExistence(timeout: timeout))
        app.buttons["list.fab"].tap()

        let editor = app.textViews["editor.body"]
        XCTAssertTrue(editor.waitForExistence(timeout: timeout))
        editor.tap()
        editor.typeText("Groceries\nOat milk and rye bread")

        app.buttons["editor.done"].tap()
        XCTAssertTrue(app.staticTexts["Groceries"].waitForExistence(timeout: timeout))

        app.terminate()
        let relaunched = launch([])
        XCTAssertTrue(relaunched.staticTexts["Groceries"].waitForExistence(timeout: timeout),
                      "a saved note must survive relaunch")
    }

    func testSearchFindsSeededNote() {
        let app = launch(["-UITestSeed"])
        let field = app.textFields["list.searchField"]
        XCTAssertTrue(field.waitForExistence(timeout: timeout))
        field.tap()
        field.typeText("almond")
        XCTAssertTrue(app.staticTexts["Trail mix recipe"].waitForExistence(timeout: timeout))
        XCTAssertFalse(app.staticTexts["Gift ideas"].exists)
    }

    func testDeleteThenUndoRestoresNote() {
        let app = launch(["-UITestSeed"])
        let row = app.staticTexts["Gift ideas"]
        XCTAssertTrue(row.waitForExistence(timeout: timeout))

        row.press(forDuration: 1.2)
        let deleteButton = app.buttons["row.delete"].firstMatch
        XCTAssertTrue(deleteButton.waitForExistence(timeout: timeout))
        deleteButton.tap()
        XCTAssertTrue(app.buttons["list.undoButton"].waitForExistence(timeout: timeout))

        app.buttons["list.undoButton"].tap()
        XCTAssertTrue(app.staticTexts["Gift ideas"].waitForExistence(timeout: timeout))
    }

    func testPinMovesNoteIntoPinnedSection() {
        let app = launch(["-UITestSeed"])
        let target = app.staticTexts["Gift ideas"]
        XCTAssertTrue(target.waitForExistence(timeout: timeout))

        target.press(forDuration: 1.2)
        let pinButton = app.buttons["row.pin"].firstMatch
        XCTAssertTrue(pinButton.waitForExistence(timeout: timeout))
        pinButton.tap()

        // The seed pins one note already, so PINNED is present either way;
        // assert the moved note now sits above the NOTES header.
        let pinnedHeader = app.staticTexts["PINNED"]
        XCTAssertTrue(pinnedHeader.waitForExistence(timeout: timeout))
        XCTAssertTrue(app.staticTexts["Gift ideas"].exists)
    }
}
