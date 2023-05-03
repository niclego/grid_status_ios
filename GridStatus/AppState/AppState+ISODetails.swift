import Core
import GridStatusCommonUI

extension AppState {
    private var core: CoreProtocol {
        Core(networkManager: NetworkManagerMock())
    }

    // MARK: - Requests
    private var getIsoDetails: () async throws -> ISODetailsResponse {
        return core.requestGenerator (
            request: GetISODetailsRequest()
        )
    }

    private var stream: AsyncThrowingStream<ISODetailsResponse, Error> {
        return core.streamGenerator (
            sleeper: Sleeper(durationInSeconds: 60),
            action: getIsoDetails
        )
    }
    
    // MARK: - ISO Details Interacors

    private func isosFrom(_ response: ISODetailsResponse) -> [ISOViewItem] {
        response.data.map { .init(iso: $0) }
    }
    
    func fetchIsos() async throws {
        let resp = try await getIsoDetails()
        guard !resp.data.isEmpty else { throw GridStatusError.noIsosData }
        await publish(isos: isosFrom(resp))
    }

    func subscribe() async throws {
        for try await resp in stream {
            await publish(isos: isosFrom(resp))
        }
    }
}
