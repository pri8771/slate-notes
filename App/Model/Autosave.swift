import Foundation

/// Debounced autosave. Interval is injectable so tests run in milliseconds.
@MainActor
final class Autosave {
    private let interval: Duration
    private let perform: () -> Void
    private var task: Task<Void, Never>?

    init(interval: Duration = .milliseconds(400), perform: @escaping () -> Void) {
        self.interval = interval
        self.perform = perform
    }

    /// Restarts the timer; fires once after the caller stops typing.
    func schedule() {
        task?.cancel()
        task = Task { [interval, perform] in
            try? await Task.sleep(for: interval)
            guard !Task.isCancelled else { return }
            perform()
        }
    }

    /// Cancels any pending fire and saves immediately.
    func flush() {
        task?.cancel()
        task = nil
        perform()
    }
}
