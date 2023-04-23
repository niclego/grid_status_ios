import Foundation

struct DateFormatters {
    private static let LocalDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    static func utcStringToLocalDisplay(
        localFormatter: DateFormatter = LocalDisplayFormatter,
        isoFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
    ) -> (String) -> String {
        return { utcDateString in
            guard let isoDate = isoFormatter.date(from: utcDateString) else { return "" }
            return localFormatter.string(from: isoDate)
        }
    }
}
