struct Sleeper: Sleepable {
    func sleep(seconds: Int) async throws {
        let nanoSeconds = seconds * 1_000_000_000
        try await Task.sleep(nanoseconds: UInt64(nanoSeconds))
    }
}
