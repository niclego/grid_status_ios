protocol NetworkManagable {
    func request<T: Decodable>(request: Requestable) async throws -> T
}
