import Core
import GridStatusCommonUI

extension AppState { // + chartConfig

    // MARK: - Requests
    private func getFiveMinData(isoId: String, startTime: String, endTime: String) -> () async throws -> StandardFiveMinuteResponse {
        return core.requestGenerator (
            request: GetFiveMinDataRequest(
                isoId: isoId,
                startTime: startTime,
                endTime: endTime
            )
        )
    }

    // MARK: - Five Minute Data Interactors
    func fetchFiveMinData(
        isoId: String,
        startTimeUtc: String,
        endTimeUtc: String
    ) async throws -> [StackedAreaChartItem] {
        let resp = try await getFiveMinData(
            isoId: isoId,
            startTime: startTimeUtc,
            endTime: endTimeUtc
        )()

        guard !resp.data.isEmpty else { throw NetworkError.invalidResponse }
        return resp.data.map { .init($0) }
    }
}
