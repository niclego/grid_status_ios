import Combine
import Foundation
import grid_status_common_ui
import grid_status_core

class ViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var loadingState: LoadableContent.LoadingState = .error
    @Published var isos = [ISOViewItem]()
    @Published var selectedIso: ISOViewItem? = nil
    
    // MARK: - Constants
    private let core: CoreProtocol
    
    // MARK: - Variables
    private var fetchIsosInProgress = false
    
    // MARK: - Lifecycle
    init(
        core: CoreProtocol = Core(networkManager: NetworkManagerMock())
    ) {
        self.core = core
    }
    
    // MARK: - Networking
    var task: Task<(), Error>?
    
    func subscribe() {
        unsubscribe()

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
                    print("[Recieved stream response")
                    await publish(isosResponse: isosResponse)
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
            name: iso.iso,
            primarySource: iso.latestPrimaryPowerSource,
            load: iso.latestLoad,
            price: iso.latestLmp,
            updatedTimes: (lmpTimeUtc: iso.lmpTimeUtc, loadTimeUtc: iso.loadTimeUtc, primaryPowerSourceTimeUtc: iso.primaryPowerSourceTimeUtc)
        )
    }
}

