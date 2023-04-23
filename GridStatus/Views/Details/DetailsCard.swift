import SwiftUI

struct DetailsCard: View {
    let iso: ISO

    var body: some View {
        VStack(spacing: 10) {
            DetailsCardHeader(
                displayName: iso.displayName,
                updatedTime: iso.updatedTime
            )
            DetailsCardData(
                displayPrimarySource: iso.displayPrimarySource,
                displayLoad: iso.displayLoad,
                displayPrice: iso.displayPrice
            )
        }
    }
}

struct DetailsCard_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCard(iso: ISO.example).padding()
    }
}
