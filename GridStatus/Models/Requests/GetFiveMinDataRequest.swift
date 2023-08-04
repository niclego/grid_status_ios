import Core

public struct GetFiveMinDataRequest: Requestable {
    init(isoId: String, startTime: String, endTime: String) {
        self.path = "/query/\(isoId)_standardized_5_min"
        
        self.queryItems = [
            "api_key": "939aa86d1b46813c99b1ff057627069a",
            "start_time": startTime,
            "end_time": endTime
        ]
    }

    public var responseMock: StandardFiveMinuteResponse {
        StandardFiveMinuteResponse.example
    }
    public let path: String
    public let httpMethod = NetworkManager.HttpMethod.get.method
    public let domain = "https://api.gridstatus.io"
    public let queryItems: [String: String]
}
