import GridStatusCommonUI
import Combine

class AppState: ObservableObject {
    @Published private(set) var isos = [ISOViewItem]()
    @Published private(set) var stackedAreaChartConfig: StackedAreaChartConfig?

    @MainActor
    func publish(isos: [ISOViewItem]) {
        self.isos = isos
    }
    
    @MainActor
    func publish(stackedAreaChartConfig: StackedAreaChartConfig?) {
        self.stackedAreaChartConfig = stackedAreaChartConfig
    }
}
