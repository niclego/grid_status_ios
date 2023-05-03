import Core

public struct GetISODetailsRequest: Requestable {
    public init() {}

    public var responseMock: ISODetailsResponse {
        ISODetailsResponse.example
    }

    public let httpMethod = NetworkManager.HttpMethod.get.method
    public let domain = "https://api.gridstatus.io"
    public let path = "/query/isos_latest"
    public let queryItems = ["api_key": ""]
}
