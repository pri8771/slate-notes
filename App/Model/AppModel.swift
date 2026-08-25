import Foundation
import SwiftData
import SwiftUI

/// Owns container creation. `@Query` is synchronous, so building the store is
/// the app's only genuine loading/failure surface — modeling it keeps the
/// loading and error states honest instead of decorative.
@Observable
@MainActor
final class AppModel {

    enum Phase {
        case loading
        case ready(ModelContainer)
        case failed(String)
    }

    private(set) var phase: Phase = .loading

    /// Launch arguments used by UI tests to control the on-disk store.
    static let resetFlag = "-UITestReset"
    static let seedFlag = "-UITestSeed"

    func start(arguments: [String] = ProcessInfo.processInfo.arguments) {
        if case .ready = phase { return }
        phase = .loading
        do {
            let container = try ModelContainer(for: Note.self)
            applyTestArguments(arguments, in: container)
            phase = .ready(container)
        } catch {
            phase = .failed("Slate couldn't open your notes.")
        }
    }

    func retry() {
        phase = .loading
        start()
    }

    private func applyTestArguments(_ arguments: [String], in container: ModelContainer) {
        let reset = arguments.contains(Self.resetFlag)
        let seed = arguments.contains(Self.seedFlag)
        guard reset || seed else { return }

        let store = NotesStore(context: ModelContext(container))
        store.deleteAll()
        guard seed else { return }

        let now = Date()
        // Fixtures mirror the design boards so UI tests read like the mockups.
        let pinned = store.create(
            text: "Packing — Goa trip\nSunscreen, chargers, the blue kurta, book for the flight.",
            now: now.addingTimeInterval(-3600)
        )
        store.setPinned(pinned, true)
        store.create(
            text: "Trail mix recipe\nAlmonds, dried mango, dark chocolate chips, a pinch of sea salt.",
            now: now.addingTimeInterval(-7200)
        )
        store.create(
            text: "Gift ideas\nCeramic pour-over, that linen apron, film camera.",
            now: now.addingTimeInterval(-10800)
        )
        store.save()
    }
}
