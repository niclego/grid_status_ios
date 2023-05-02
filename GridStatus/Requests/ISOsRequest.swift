import grid_status_core

public struct GetISOsLatestRequest: Requestable {
    public init() {}

    public var responseMock: ISOLatestResponse {
        ISOLatestResponse.example
    }

    public let httpMethod = NetworkManager.HttpMethod.get.method
    public let domain = "https://api.gridstatus.io"
    public let path = "/query/isos_latest"
    public let queryItems = [String: String]()
}
