import Foundation

/// Date formatting for rows and the editor header. `now` and `calendar` are
/// injected so tests never depend on the wall clock.
enum NoteDate {

    /// Time for today, weekday within the last week, else M/d/yy.
    static func rowLabel(
        for date: Date,
        relativeTo now: Date = Date(),
        calendar: Calendar = .current
    ) -> String {
        if calendar.isDateInToday(date) {
            return timeFormatter.string(from: date)
        }
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }
        if let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: date),
                                              to: calendar.startOfDay(for: now)).day,
           days > 0, days < 7 {
            return weekdayFormatter.string(from: date)
        }
        return shortDateFormatter.string(from: date)
    }

    /// "August 24, 2026 · 9:41 AM"
    static func editorHeader(for date: Date) -> String {
        "\(longDateFormatter.string(from: date)) · \(timeFormatter.string(from: date))"
    }

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .none; f.timeStyle = .short; return f
    }()
    private static let weekdayFormatter: DateFormatter = {
        let f = DateFormatter(); f.setLocalizedDateFormatFromTemplate("EEEE"); return f
    }()
    private static let shortDateFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .short; f.timeStyle = .none; return f
    }()
    private static let longDateFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .long; f.timeStyle = .none; return f
    }()
}
