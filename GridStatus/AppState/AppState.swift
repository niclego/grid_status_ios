import GridStatusCommonUI
import Combine
import Core

protocol AppStateable: ObservableObject {
    typealias ChartConfig = StackedAreaChartConfig
    func publish(isos: [ISOViewItem])
    func publish(chartConfig: ChartConfig?)
}

class AppState: ObservableObject, AppStateable {
    @Published private(set) var isos = [ISOViewItem]()
    @Published private(set) var chartConfig: ChartConfig?
    
    let core = Core(networkManager: NetworkManager())

    @MainActor
    func publish(isos: [ISOViewItem]) {
        self.isos = isos
    }
    
    @MainActor
    func publish(chartConfig: ChartConfig?) {
        self.chartConfig = chartConfig
    }
}
