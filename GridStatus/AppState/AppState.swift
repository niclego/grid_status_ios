import GridStatusCommonUI
import Combine
import Core

protocol AppStateable: ObservableObject {
    typealias ChartConfig = StackedAreaChartConfig
    func publish(isos: [ISOViewItem])
    func publish(chartConfig: ChartConfig?)
}

//class AppStateMock: AppStateable {
//    let core = Core(networkManager: NetworkManager())
//
//    var isos = [ISOViewItem]()
//    var chartConfig: ChartConfig? = .example
//
//    func publish(isos: [GridStatusCommonUI.ISOViewItem]) {
//        self.isos = [ISOViewItem.example]
//    }
//
//    func publish(chartConfig: ChartConfig?) {
//        self.chartConfig = .example
//    }
//}

class AppState: ObservableObject, AppStateable {
    @Published private(set) var isos = [ISOViewItem]()
    @Published private(set) var chartConfig: ChartConfig?
    
    let core = Core(networkManager: NetworkManagerMock())

    @MainActor
    func publish(isos: [ISOViewItem]) {
        self.isos = isos
    }
    
    @MainActor
    func publish(chartConfig: ChartConfig?) {
        self.chartConfig = chartConfig
    }
}
