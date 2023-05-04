import Core
import GridStatusCommonUI

extension AppState { // + chartConfig

    // MARK: - Requests
    private func getFiveMinData(isoId: String) -> () async throws -> StandardFiveMinuteResponse {
        return core.requestGenerator (
            request: GetFiveMinDataRequest(isoId: isoId)
        )
    }

    // MARK: - Five Minute Data Interactors
    private func areaChartConfig(from resp: StandardFiveMinuteResponse, and isoId: String) -> ChartConfig {
        let items: [StackedAreaChartItem] = resp.data.enumerated()
            .compactMap {
                $0.offset.isMultiple(of: 3) ? .init(data: $0.element) : nil
            }
        let dataType: String = "Fuel Mix"
        
        return ChartConfig(data: items, isoId: isoId, dataType: dataType, showXAxis: true, showYAxis: true, showLegend: true)
    }

    func fetchFiveMinData(isoId: String) async throws {
        let resp = try await getFiveMinData(isoId: isoId)()
        guard !resp.data.isEmpty else { throw NetworkError.invalidResponse }
        let config = areaChartConfig(from: resp, and: isoId)
        await publish(chartConfig: config)
    }
    
    @MainActor
    func clear() {
        publish(chartConfig: nil)
    }
}
