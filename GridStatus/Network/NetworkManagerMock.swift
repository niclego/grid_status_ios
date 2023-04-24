struct NetworkManagerMock: NetworkManagable {
    func request<T>(request: Requestable) async throws -> T where T : Decodable {
        print("Mock request completed")
        return ISOLatestResponse.example as! T
    }
}
