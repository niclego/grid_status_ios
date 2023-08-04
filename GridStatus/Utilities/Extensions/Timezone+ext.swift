import Foundation

extension TimeZone {
    static func on(isoId: String) -> TimeZone {
        switch isoId {
        case "caiso": return TimeZone(abbreviation: "PST")!
        case "ercot": return TimeZone(abbreviation: "CDT")!
        case "isone": return TimeZone(abbreviation: "EST")!
        case "miso": return TimeZone(abbreviation: "EST")!
        case "nyiso": return TimeZone(abbreviation: "EST")!
        case "pjm": return TimeZone(abbreviation: "EST")!
        case "spp": return TimeZone(abbreviation: "CDT")!
        default: return .current
        }
    }
}
