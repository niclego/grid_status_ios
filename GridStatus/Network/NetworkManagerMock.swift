struct NetworkManagerMock: NetworkManagable {
    func request<T>(request: Requestable) async throws -> T where T : Decodable {
        return ISOLatestResponse.example as! T
    }
}
