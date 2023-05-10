import Foundation

public struct ISOResponse: Decodable {
    public let data: [ISO]
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case statusCode = "status_code"
    }
}

extension ISOResponse {
    public static let example: ISOResponse = {
        if let path = Bundle.main.path(forResource: "isos_latest_query_response", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let resp = try JSONDecoder().decode(ISOResponse.self, from: data)
                return resp
            } catch {
                return .init(data: [], statusCode: 400)
            }
        }
        
        return .init(data: [], statusCode: 400)
    }()
}
