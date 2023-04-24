import Combine
import Foundation
import grid_status_core

class ViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var loadingState: LoadableContent.LoadingState = .noData
    @Published var isos = [ISOViewItem]()
    @Published var selectedIso: ISOViewItem? = nil
    
    // MARK: - Constants
    private let core: CoreProtocol
    
    // MARK: - Variables
    private var fetchIsosInProgress = false
    
    // MARK: - Lifecycle
    init(
        core: CoreProtocol = Core(networkManager: NetworkManager(apiKey: "939aa86d1b46813c99b1ff057627069a"))
    ) {
        self.core = core
    }
    
    // MARK: - Networking
    var task: Task<(), Error>?
    
    func subscribe() {
        task?.cancel()
        task = nil

        let getISOsLatest: GetISOsLatestRequest.Action = core.requestGenerator(
            request: GetISOsLatestRequest()
        )

        let stream = core.streamGenerator(
            sleeper: Sleeper(durationInSeconds: 60),
            action: getISOsLatest
        )
        
        task = Task {
            do {
                if loadingState == .noData || loadingState == .error {
                    await publish(state: .loading)
                    let isosResponse = try await getISOsLatest()
                    await publish(isosResponse: isosResponse)
                }

                for try await isosResponse in stream {
                    await publish(isosResponse: isosResponse)
                }
            } catch {
                await publish(state: .error)
            }
        }
    }
    
    @MainActor
    private func publish(state: LoadableContent.LoadingState) {
        self.loadingState = state
    }
    
    @MainActor
    private func publish(isosResponse: ISOLatestResponse) {
        let isos = isosResponse.data
        
        if isos.isEmpty {
            self.loadingState = .error
        } else {
            self.isos = isos.map { ViewModel.dataToViewItem(iso: $0) }
            self.loadingState = .loaded
        }
    }
}

// MARK: - Data to View Item logic
extension ViewModel {
    static func dataToViewItem(iso: ISO) -> ISOViewItem {
        .init(
            id: iso.iso,
            name: ViewModel.displayName(for: iso.iso),
            primarySource: ViewModel.displaySource(for: iso.latestPrimaryPowerSource),
            load: ViewModel.displayLoad(for: iso.latestLoad),
            price: ViewModel.displayPrice(for: iso.latestLmp),
            updatedTime: ViewModel.mostUpdatedTime(for: (
                lmpTime: iso.lmpTimeUtc,
                loadTime: iso.loadTimeUtc,
                powerSourceTime: iso.primaryPowerSourceTimeUtc
            ))
        )
    }
    
    private static func mostUpdatedTime(for latestTimes: (lmpTime: String, loadTime: String, powerSourceTime: String)) -> String {
        let formatter = ISO8601DateFormatter()
        let (lmpTime, loadTime, powerSourceTime ) = latestTimes
        guard
            let lmpDate = formatter.date(from: lmpTime),
            let loadDate = formatter.date(from: loadTime),
            let pSourceDate = formatter.date(from: powerSourceTime)
        else { return "--" }
        
        let max = max(lmpDate, loadDate, pSourceDate)
        
        let diffComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: max, to: Date.now)
        
        var unit: String?
        var value: Int?
        if let year = diffComponents.year, year != 0 {
            value = year
            unit = year == 1 ? "year" : "years"
        } else if let month = diffComponents.month, month != 0 {
            value = month
            unit = month == 1 ? "month" : "months"
        } else if let day = diffComponents.day, day != 0 {
            value = day
            unit = day == 1 ? "day" : "days"
        } else if let hours = diffComponents.hour, hours != 0 {
            value = hours
            unit = hours == 1 ? "hour" : "hours"
        } else if let minutes = diffComponents.minute, minutes != 0 {
            value = minutes
            unit = minutes == 1 ? "minute" : "minutes"
        }
        
        // MARK: - TODO

        return "1 minute ago"
    }
    
    private static func displayPrice(for latestLmp: Double) -> String {
        return "$\(Int(round(latestLmp))) /MWh"
    }
    
    private static func displayLoad(for latestLoad: Double) -> String {
        return "\(Int(round(latestLoad))) MW"
    }
    
    private static func displaySource(for latestPrimaryPowerSource: String) -> String {
        let sourceStr = latestPrimaryPowerSource.replacingOccurrences(of: "_", with: " ")
        return sourceStr.capitalized
    }
    
    private static func displayName(for iso: String) -> String {
        switch iso {
        case "caiso":
            return "California ISO"
        case "pjm":
            return "PJM"
        case "isone":
            return "ISO New England"
        case "spp":
            return "Southwest Power Pool"
        case "nyiso":
            return "New York ISO"
        case "miso":
            return "Midcontinent ISO"
        case "ercot":
            return "ERCOT"
        default:
            return ""
        }
    }
}

