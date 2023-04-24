import Foundation

struct ISOViewItem: Identifiable, Equatable {
    let id: String
    let name: String
    let primarySource: String
    let load: String
    let price: String
    let updatedTime: String
}

extension ISOViewItem {
    fileprivate init() {
        self.id = "caiso"
        self.name = "California ISO"
        self.primarySource = "Solar"
        self.load = "14,0123 MW"
        self.price = "$14 /MWh"
        self.updatedTime = "1 minute ago"
    }
    
    static let example: ISOViewItem = ISOViewItem()
}
