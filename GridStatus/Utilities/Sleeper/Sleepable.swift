protocol Sleepable {
    func sleep(seconds: Int) async throws -> Void
}
