import grid_status_core
import grid_status_common_ui

extension AppState {
    private var core: CoreProtocol {
        Core(networkManager: NetworkManagerMock())
    }

    // MARK: - Requests
    private var getIsosRequest: GetISOsLatestRequest.Action {
        return core.requestGenerator (
            request: GetISOsLatestRequest()
        )
    }

    private var stream: AsyncThrowingStream<ISOLatestResponse, Error> {
        return core.streamGenerator (
            sleeper: Sleeper(durationInSeconds: 60),
            action: getIsosRequest
        )
    }
    
    // MARK: - AppState Interacors

    private func isosFrom(_ response: ISOLatestResponse) -> [ISOViewItem] {
        response.data.map { .init(iso: $0) }
    }
    
    func fetchIsos() async throws {
        let resp = try await getIsosRequest()
        guard !resp.data.isEmpty else { throw GridStatusError.noIsosData }
        await publish(isos: isosFrom(resp))
    }

    func subscribe() async throws {
        for try await resp in stream {
            await publish(isos: isosFrom(resp))
        }
    }
}
