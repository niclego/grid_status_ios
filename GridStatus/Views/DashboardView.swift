// https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-programmatic-navigation-in-swiftui

import GridStatusCommonUI
import SwiftUI

struct DashboardView: View {
    @Environment(\.colorScheme) var colorScheme

    @StateObject var appState: AppState
    
    @State var selectedIso: ISOViewItem? = nil
    @State var loadingState: LoadableContent.LoadingState = .noData

    var body: some View {
        VStack {
            HStack {
                GridStatusHeaderView()
                Spacer()
            }.padding([.top, .leading])
            
            Spacer()
            
            LoadableContent.ContainerView(loadingState: loadingState) {
                ErrorRetryView (
                    retryAction: {}
                )
            } content: {
                ISOCardList(isos: appState.isos) { iso in
                    selectedIso = iso
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(GridStatusColor.dashboardBackground.color(scheme: colorScheme))
        .onAppear {
            loadingState = .loading
            Task {
                try await appState.fetchIsos()
                loadingState = .loaded
                try await appState.subscribe()
            }
        }
        .refreshable {
            Task {
                try await appState.fetchIsos()
            }
        }
        .sheet(item: $selectedIso) { iso in
            ChartsView(iso: iso)
                .padding()
                .presentationBackground(GridStatusColor.dashboardBackground.color(scheme: colorScheme))
        }
        .environmentObject(appState)
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(
            appState: AppState()
        )
    }
}
