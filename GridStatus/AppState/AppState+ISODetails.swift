import Core
import GridStatusCommonUI

extension AppState {
    private var core: CoreProtocol {
        Core(networkManager: NetworkManager())
    }

    // MARK: - Requests
    private var getIsoDetails: () async throws -> ISODetailsResponse {
        return core.requestGenerator (
            request: GetISODetailsRequest()
        )
    }
    
    private func getFiveMinData(isoId: String) -> () async throws -> StandardFiveMinuteResponse {
        return core.requestGenerator (
            request: GetFiveMinDataRequest(isoId: isoId)
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
    
    // MARK: - Five Minute Data Interactors
    private func areaChartConfig(from resp: StandardFiveMinuteResponse, and isoId: String) -> StackedAreaChartConfig {
        let items: [StackedAreaChartItem] = resp.data.map { .init(data: $0) }
        let dataType: String = "Fuel Mix"
        
        return StackedAreaChartConfig(data: items, isoId: isoId, dataType: dataType, showXAxis: true, showYAxis: true)
    }

    func fetchFiveMinData(isoId: String) async throws {
        let resp = try await getFiveMinData(isoId: isoId)()
        guard !resp.data.isEmpty else { throw NetworkError.invalidResponse }
        await publish(stackedAreaChartConfig: areaChartConfig(from: resp, and: isoId))
    }
    
    @MainActor
    func clear() {
        publish(stackedAreaChartConfig: nil)
    }
}
