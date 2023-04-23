import Combine

class ViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var error: String?
    @Published var isos = [ISO]()
    @Published var selectedIso: ISO? = nil
    
    // MARK: - Constants
    private let networkManager: NetworkManagable
    
    // MARK: - Variables
    private var fetchIsosInProgress = false

    // MARK: - Lifecycle
    init(networkManager: NetworkManagable = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: - Networking
    @MainActor
    func fetchIsos() async {
        defer {
            fetchIsosInProgress = false
        }

        guard fetchIsosInProgress == false else { return }
        
        do {
            fetchIsosInProgress = true
            let response: ISOLatestResponse = try await networkManager.request(request: ISOLatestRequest.factory)

            isos = response.data
        } catch {
            self.error = error.localizedDescription
        }
    }
}
