import grid_status_common_ui
import SwiftUI

struct ChartsContainer: View {
    @EnvironmentObject var vm: ViewModel
    
    let iso: ISOViewItem

    var body: some View {
        ScrollView {
            VStack {
                ISODetailsCard(iso: iso)

                Spacer()
                
                // Charts Views
            }
        }
    }
}

struct ChartsContainer_Previews: PreviewProvider {
    static var previews: some View {
        ChartsContainer(iso: ISOViewItem.example)
            .environmentObject(ViewModel()).padding()
    }
}
