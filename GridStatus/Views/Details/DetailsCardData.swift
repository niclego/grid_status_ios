import SwiftUI

struct DetailsCardData: View {
    let displayPrimarySource: String
    let displayLoad: String
    let displayPrice: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                DetailsCardDataLabelText(value: "Load")
                DetailsCardDataText(value: displayLoad)
            }
            Spacer()
            VStack(spacing: 5) {
                DetailsCardDataLabelText(value: "Price")
                DetailsCardDataText(value: displayPrice)
                
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 5) {
                DetailsCardDataLabelText(value: "Main Source")
                DetailsCardDataText(value: displayPrimarySource)
                
            }
        }
    }
}

struct DetailsCardData_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCardData(displayPrimarySource: ISO.example.displayPrimarySource, displayLoad: ISO.example.displayLoad, displayPrice: ISO.example.displayPrice).padding()
    }
}
