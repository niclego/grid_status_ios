import Foundation

struct NetworkManager: NetworkManagable {
    let session = URLSession.shared
    
    let defaultQueryParams: [String: String] = [
        "api_key": "939aa86d1b46813c99b1ff057627069a"
    ]

    enum ManagerErrors: Error {
        case invalidRequestURL
        case invalidQueryItems
        case invalidResponse
        case invalidStatusCode(Int)
    }

    enum HttpMethod: String {
        case get
        case post

        var method: String { rawValue.uppercased() }
    }

    func request<T: Decodable>(
        request: Requestable
    ) async throws -> T {
        guard var urlComponents = URLComponents(string: request.domain + request.path) else { throw ManagerErrors.invalidRequestURL }
        
        var queryItems = defaultQueryParams
        request.queryItems.forEach { (key, value) in
            queryItems[key] = value
        }

        urlComponents.queryItems = queryItems.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }

        guard let url = urlComponents.url else { throw ManagerErrors.invalidQueryItems }
        
        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod

        let ( data, response ) = try await session.data(for: request)
        
        guard let urlResponse = response as? HTTPURLResponse else { throw ManagerErrors.invalidResponse }

        guard urlResponse.statusCode == 200 else { throw ManagerErrors.invalidStatusCode(urlResponse.statusCode) }
        
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}
