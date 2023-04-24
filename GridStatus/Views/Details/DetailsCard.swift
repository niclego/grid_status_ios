import SwiftUI

struct DetailsCard: View {
    let iso: ISOViewItem

    var body: some View {
        VStack(spacing: 10) {
            DetailsCardHeader(
                displayName: iso.name,
                updatedTime: iso.updatedTime
            )
            DetailsCardData(
                displayPrimarySource: iso.primarySource,
                displayLoad: iso.load,
                displayPrice: iso.price
            )
        }
        .padding()
        .background(.background)
        .cornerRadius(12)
    }
}

struct DetailsCard_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCard(iso: ISOViewItem.example).padding()
    }
}
