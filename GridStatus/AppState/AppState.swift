import GridStatusCommonUI
import Combine
import Core

protocol AppStateable: ObservableObject {
    func publish(isos: [ISOViewItem])
}

class AppState: ObservableObject, AppStateable {
    @Published private(set) var isos = [ISOViewItem]()

    let core = Core(networkManager: NetworkManagerMock())

    @MainActor
    func publish(isos: [ISOViewItem]) {
        self.isos = isos
    }
}
