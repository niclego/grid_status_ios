import grid_status_common_ui
import SwiftUI

struct ChartsView: View {
    @EnvironmentObject var appState: AppState
    
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

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView(iso: ISOViewItem.example)
            .environmentObject(AppState()).padding()
    }
}
