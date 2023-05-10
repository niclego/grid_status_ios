import Foundation

extension Date {
    private func convert(
        fromTimeZone timeZone: TimeZone,
        to destinationTimeZone: TimeZone
    ) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents(in: timeZone, from: self)
        components.timeZone = destinationTimeZone
        return calendar.date(from: components)!
    }
    
    static func oneDayStartEndDate(
        for startDate: Date,
        with timeZone: TimeZone
    ) -> (start: Date, end: Date) {
        let startDate = Calendar.current.startOfDay(for: startDate)
        let newStartDate = startDate.convert(fromTimeZone: .current, to: timeZone)
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        let newEndDate = endDate.convert(fromTimeZone: .current, to: timeZone)

        return (start: newStartDate, newEndDate)
    }
    
    var utcString: String {
        ISO8601DateFormatter().string(from: self)
    }
}
