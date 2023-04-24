import Combine
import Foundation

class ViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var loadingState: LoadableContent.LoadingState = .loading
    @Published var isos = [ISO]()
    @Published var selectedIso: ISO? = nil
    
    // MARK: - Constants
    private let networkManager: NetworkManagable
    private let sleeper: Sleepable
    
    // MARK: - Variables
    private var fetchIsosInProgress = false
    
    // MARK: - Lifecycle
    init(
        networkManager: NetworkManagable = NetworkManager(),
        sleeper: Sleepable = Sleeper()
    ) {
        self.networkManager = networkManager
        self.sleeper = sleeper
    }
    
    // MARK: - Networking
    var task: Task<(), Error>?
    
    private func isoStream(
        sleeper: Sleepable,
        fetchIsos: @escaping () async throws -> [ISO]
    ) -> AsyncThrowingStream<[ISO], Error> {
        return AsyncThrowingStream {            
            try await sleeper.sleep(seconds: 1)
            let isos = try await fetchIsos()
            return isos
        }
    }
    
    func subscribe() {
        loadingState = .loading

        let networkManager = networkManager
        let sleeper = sleeper

        let stream = isoStream(
            sleeper: sleeper,
            fetchIsos: fetchIsos(
                networkManager: networkManager
            )
        )
        
        task = Task {
            do {
                for try await isos in stream {
                    await publish(isos: isos)
                }
            } catch {
                await publish(error: error)
            }
        }
    }
    
    @MainActor
    private func publish(error: Error) {
        self.loadingState = .error(error: error)
    }
    
    @MainActor
    private func publish(isos: [ISO]) {
        self.loadingState = .loaded
        self.isos = isos
    }
    
    private func fetchIsos(
        networkManager: NetworkManagable
    ) -> () async throws  -> [ISO] {
        return {
            let response: ISOLatestResponse = try await networkManager.request(request: ISOLatestRequest.factory)
            let isos = response.data
            if isos.isEmpty {
                throw GridStatusError.noData
            }
            return isos
        }
    }
}
