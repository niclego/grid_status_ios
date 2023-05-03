import Foundation

struct StandardFiveMinute: Decodable, Identifiable {
    let startUTC: String
    let dualFuel: Double?
    let hydro: Double?
    let natural_gas: Double?
    let nuclear: Double?
    let otherFossilFuels: Double?
    let otherRenewables: Double?
    let wind: Double?
    
    var id: String { startUTC }
    
    func loadInGW(load: Double?) -> Double {
        guard let load = load else { return 0 }
        return load / 1000
    }
    
    enum CodingKeys: String, CodingKey {
        case startUTC = "interval_start_utc"
        case dualFuel = "fuel_mix.dual_fuel"
        case hydro = "fuel_mix.hydro"
        case natural_gas = "fuel_mix.natural_gas"
        case nuclear = "fuel_mix.nuclear"
        case otherFossilFuels = "fuel_mix.other_fossil_fuels"
        case otherRenewables = "fuel_mix.other_renewables"
        case wind = "fuel_mix.wind"
    }
}

public struct StandardFiveMinuteResponse: Decodable {
    let data: [StandardFiveMinute]
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
    }
}

extension StandardFiveMinute {
    static let example: StandardFiveMinuteResponse = {
        if let path = Bundle.main.path(forResource: "nyiso_standardized_5_min_response", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let resp = try JSONDecoder().decode(StandardFiveMinuteResponse.self, from: data)
                return resp
            } catch {
                return .init(data: [], statusCode: 400)
            }
        }
        
        return .init(data: [], statusCode: 400)
    }()
}
