import Foundation

struct StandardFiveMinute: Decodable, Identifiable {
    let startUTC: String

    let batteries: Double?
    let biomass: Double?
    let coal: Double?
    let coalAndLignite: Double?
    let duelFuel: Double?
    let geothermal: Double?
    let imports: Double?
    let hydro: Double?
    let largeHydro: Double?
    let naturalGas: Double?
    let nuclear: Double?
    let oil: Double?
    let other: Double?
    let solar: Double?
    let wind: Double?
    
    var id: String { startUTC }
    
    enum CodingKeys: String, CodingKey {
        case startUTC = "interval_start_utc"

        case batteries = "fuel_mix.batteries"
        case biomass = "fuel_mix.biomass"
        case coal = "fuel_mix.coal"
        case coalAndLignite = "fuel_mix.coal_and_lignite"
        case duelFuel = "fuel_mix.dual_fuel"
        case geothermal = "fuel_mix.geothermal"
        case imports = "fuel_mix.imports"
        case hydro = "fuel_mix.hydro"
        case largeHydro = "fuel_mix.large_hydro"
        case naturalGas = "fuel_mix.natural_gas"
        case nuclear = "fuel_mix.nuclear"
        case oil = "fuel_mix.oil"
        case other = "fuel_mix.other"
        case solar = "fuel_mix.solar"
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

extension StandardFiveMinuteResponse {
    static let example: StandardFiveMinuteResponse = {
        if let path = Bundle.main.path(forResource: "caiso_standardized_5_min_response", ofType: "json") {
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
