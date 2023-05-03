import GridStatusCommonUI
import Combine

class AppState: ObservableObject {
    @Published private(set) var isos = [ISOViewItem]()
    
    @MainActor
    func publish(isos: [ISOViewItem]) {
        self.isos = isos
    }
}
