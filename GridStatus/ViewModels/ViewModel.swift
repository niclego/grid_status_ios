import Combine
import Foundation
import grid_status_common_ui
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
    
    // MARK: - Requests
    private var getIsosRequest: GetISOsLatestRequest.Action {
        return core.requestGenerator(
            request: GetISOsLatestRequest()
        )
    }
    
    // MARK: - Lifecycle
    init(
        core: CoreProtocol = Core(networkManager: NetworkManager(apiKey: "939aa86d1b46813c99b1ff057627069a"))
    ) {
        self.core = core
    }
    
    // MARK: - Networking
    var task: Task<(), Error>?
    
    func getIsos() async {
        await publish(state: .loading)
        
        do {
            let response = try await getIsosRequest()
            try await publish(response: response)
            await publish(state: .loaded)
        } catch {
            await publish(state: .error)
        }
    }

    func subscribe() {
        let stream = core.streamGenerator(
            sleeper: Sleeper(durationInSeconds: 60),
            action: getIsosRequest
        )
        
        task = Task {
            do {
                for try await isosResponse in stream {
                    try await publish(response: isosResponse)
                }
            } catch {
                await publish(state: .error)
            }
        }
    }
    
    func unsubscribe() {
        task?.cancel()
        task = nil
    }
    
    @MainActor
    private func publish(state: LoadableContent.LoadingState) {
        self.loadingState = state
    }
    
    @MainActor
    private func publish(response: ISOLatestResponse) throws {
        guard !response.data.isEmpty else { throw GridStatusError.noIsosData }
        let isos = response.data.map { ViewModel.dataToViewItem(iso: $0) }
        self.isos = isos
        
        if let selectedIso = selectedIso,
           let newSelectedIso = isos.first(where: { $0.id == selectedIso.id })
        {
            publish(selectedIso: newSelectedIso)
        }
    }
    
    @MainActor
    private func publish(selectedIso: ISOViewItem) {
        self.selectedIso = selectedIso
    }
}

// MARK: - Data to View Item logic
extension ViewModel {
    static func dataToViewItem(iso: ISO) -> ISOViewItem {
        .init(
            name: iso.iso,
            primarySource: iso.latestPrimaryPowerSource,
            load: iso.latestLoad,
            price: iso.latestLmp,
            updatedTimes: (lmpTimeUtc: iso.lmpTimeUtc, loadTimeUtc: iso.loadTimeUtc, primaryPowerSourceTimeUtc: iso.primaryPowerSourceTimeUtc)
        )
    }
}

