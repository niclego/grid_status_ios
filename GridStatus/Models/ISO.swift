import Foundation

struct ISO: Decodable {
    let iso: String
    let latestLmp: Double
    let latestLmpLocation: String
    let latestLmpMarket: String
    let latestLoad: Double
    let latestPrimaryPowerSource: String
    let lmpTimeUtc: String
    let loadTimeUtc: String
    let primaryPowerSourceTimeUtc: String
    
    enum CodingKeys: String, CodingKey {
        case iso
        case latestLmp = "latest_lmp"
        case latestLmpLocation = "latest_lmp_location"
        case latestLmpMarket = "latest_lmp_market"
        case latestLoad = "latest_load"
        case latestPrimaryPowerSource = "latest_primary_power_source"
        case lmpTimeUtc = "lmp_time_utc"
        case loadTimeUtc = "load_time_utc"
        case primaryPowerSourceTimeUtc = "primary_power_source_time_utc"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.iso = try container.decode(String.self, forKey: .iso)
        self.latestLmp = try container.decode(Double.self, forKey: .latestLmp)
        self.latestLmpLocation = try container.decode(String.self, forKey: .latestLmpLocation)
        self.latestLmpMarket = try container.decode(String.self, forKey: .latestLmpMarket)
        self.latestLoad = try container.decode(Double.self, forKey: .latestLoad)
        self.latestPrimaryPowerSource = try container.decode(String.self, forKey: .latestPrimaryPowerSource)
        self.lmpTimeUtc = try container.decode(String.self, forKey: .lmpTimeUtc)
        self.loadTimeUtc = try container.decode(String.self, forKey: .loadTimeUtc)
        self.primaryPowerSourceTimeUtc = try container.decode(String.self, forKey: .primaryPowerSourceTimeUtc)
    }
}

struct ISOLatestResponse: Decodable {
    let data: [ISO]
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
    }
}

extension ISOLatestResponse {
    static let example: ISOLatestResponse = {
        if let path = Bundle.main.path(forResource: "isos_latest_query_response", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let isoResponse = try JSONDecoder().decode(ISOLatestResponse.self, from: data)
                return isoResponse
            } catch {
                return ISOLatestResponse(data: [], statusCode: 400)
            }
        }
        
        return ISOLatestResponse(data: [], statusCode: 400)
    }()
}

extension ISO {
    fileprivate init() {
        self.iso = "caiso"
        self.latestLmp = 0
        self.latestLmpLocation = ""
        self.latestLmpMarket = ""
        self.latestLoad = 0
        self.latestPrimaryPowerSource = ""
        self.lmpTimeUtc = ""
        self.loadTimeUtc = ""
        self.primaryPowerSourceTimeUtc = ""
    }
    
    static let example: ISO = ISO()
}

extension ISO: Identifiable {
    var id: String { iso }
}

extension ISO {
    var displayName: String {
        switch iso {
        case "caiso":
            return "California ISO"
        case "pjm":
            return "PJM"
        case "isone":
            return "ISO New England"
        case "spp":
            return "Southwest Power Pool"
        case "nyiso":
            return "New York ISO"
        case "miso":
            return "Midcontinent ISO"
        case "ercot":
            return "ERCOT"
        default:
            return ""
        }
    }
    
    var displayPrimarySource: String {
        let sourceStr = latestPrimaryPowerSource.replacingOccurrences(of: "_", with: " ")
        return sourceStr.capitalized
    }
    
    var displayLoad: String {
        return "\(Int(round(latestLoad))) MW"
    }
    
    var displayPrice: String {
        return "$\(Int(round(latestLmp))) /MWh"
    }
    
    var updatedTime: String {
        return "1 minute ago"
    }
}
