import Core

public struct GetISODetailsRequest: Requestable {
    public init() {}

    public var responseMock: ISODetailsResponse {
        ISODetailsResponse.example
    }

    public let httpMethod = NetworkManager.HttpMethod.get.method
    public let domain = "https://api.gridstatus.io"
    public let path = "/query/isos_latest"
    public let queryItems = ["api_key": "939aa86d1b46813c99b1ff057627069a"]
}
