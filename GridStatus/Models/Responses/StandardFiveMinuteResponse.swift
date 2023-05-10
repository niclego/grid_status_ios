import Foundation

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
                print(error)
                return .init(data: [], statusCode: 400)
            }
        }
        return .init(data: [], statusCode: 400)
    }()
}
