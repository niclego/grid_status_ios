import Core

public struct GetFiveMinDataRequest: Requestable {
    public let path: String

    public init(isoId: String) {
        self.path = "/query/\(isoId)_standardized_5_min"
    }

    public var responseMock: StandardFiveMinuteResponse {
        StandardFiveMinuteResponse.example
    }

    public let httpMethod = NetworkManager.HttpMethod.get.method
    public let domain = "https://api.gridstatus.io"
    public let queryItems = [
        "api_key": "939aa86d1b46813c99b1ff057627069a",
        "start_time":"2023-05-08T04:00:00.000Z",
        "end_time":"2023-05-09T04:00:00.000Z"
    ]
}
