import Core
import GridStatusCommonUI

extension AppState { // + isos

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
    
    // MARK: - ISO Details Interactors
    private func isos(from response: ISODetailsResponse) -> [ISOViewItem] {
        response.data.map { .init(iso: $0) }
    }
    
    func fetchIsos() async throws {
        let resp = try await getIsoDetails()
        guard !resp.data.isEmpty else { throw NetworkError.invalidResponse }
        await publish(isos: isos(from: resp))
    }

    func subscribeToIsos() async throws {
        for try await resp in stream {
            await publish(isos: isos(from: resp))
        }
    }
}
