// https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-programmatic-navigation-in-swiftui

import GridStatusCommonUI
import SwiftUI

struct DashboardView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var appState: AppState
    @State var selectedIso: ISOViewItem? = nil
    
    var body: some View {
        VStack {
            HStack {
                HeaderView()
                Spacer()
            }.padding([.top, .leading])

            ISOCardList(isos: appState.isos) { iso in
                selectedIso = iso
            }
            .refreshable {
                await appState.fetchIsos()
            }
        }
        .background(GridStatusColor.dashboardBackground.color(scheme: colorScheme))
        .onAppear {
            Task {
                await appState.fetchIsos()
                await appState.subscribeToIsos()
            }
        }
        .sheet(item: $selectedIso) { iso in
            DetailsView(iso: iso)
                .padding()
                .presentationBackground(GridStatusColor.dashboardBackground.color(scheme: colorScheme))
                .presentationDragIndicator(.visible)
        }
        .environmentObject(appState)
        .onOpenURL { url in
            guard
                url.scheme == "gridstatus",
                url.host == "isoDetails"
            else { return }

            selectedIso = nil
            let id = url.pathComponents[1]
            if let iso = appState.isos.first(where: { $0.id == id }) {
                selectedIso = iso
            }
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(
            appState: AppState()
        )
    }
}
