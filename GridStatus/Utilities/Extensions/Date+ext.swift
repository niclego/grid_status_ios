import Foundation

extension Date {
    func convert(from timeZone: TimeZone, to destinationTimeZone: TimeZone) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents(in: timeZone, from: self)
        components.timeZone = destinationTimeZone
        return calendar.date(from: components)!
    }
    
    public static func timeZoneFor(isoId: String) -> TimeZone? {
        switch isoId {
        case "caiso": return TimeZone(abbreviation: "PST")
        case "ercot": return TimeZone(abbreviation: "CDT")
        case "isone": return TimeZone(abbreviation: "EST")
        case "miso": return TimeZone(abbreviation: "EST")
        case "nyiso": return TimeZone(abbreviation: "EST")
        case "pjm": return TimeZone(abbreviation: "EST")
        case "spp": return TimeZone(abbreviation: "CDT")
        default: return nil
        }
    }
}
