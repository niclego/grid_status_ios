import Core
import GridStatusCommonUI

extension AppState { // + isos

    // MARK: - Requests
    private var getIsoDetails: () async throws -> ISOResponse {
        return core.requestGenerator (
            request: GetISODetailsRequest()
        )
    }

    private var stream: AsyncThrowingStream<ISOResponse, Error> {
        return core.streamGenerator (
            sleeper: Sleeper(durationInSeconds: 60),
            action: getIsoDetails
        )
    }
    
    // MARK: - ISO Details Interactors
    private func isos(from response: ISOResponse) -> [ISOViewItem] {
        response.data.map { .init(iso: $0) }
    }
    
    func fetchIsos() async {
        do {
            let resp = try await getIsoDetails()
            guard !resp.data.isEmpty else { throw NetworkError.invalidResponse }
            await publish(isos: isos(from: resp))
        } catch {
            print(error)
        }
    }

    func subscribeToIsos() async {
        do {
            for try await resp in stream {
                await publish(isos: isos(from: resp))
            }
        } catch {
            print(error)
        }
    }
}
