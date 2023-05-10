// https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-programmatic-navigation-in-swiftui

import GridStatusCommonUI
import SwiftUI

struct DashboardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var appState: AppState
    
    @State var selectedIso: ISOViewItem? = nil
    @State var loadingState: LoadableContent.LoadingState = .noData
    @State private var presentedNumbers = [Int]()
    
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
                .refreshable {
                    Task {
                        try await appState.fetchIsos()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(GridStatusColor.dashboardBackground.color(scheme: colorScheme))
        .onAppear {
            loadingState = .loading
            Task {
                do {
                    try await appState.fetchIsos()
                    loadingState = .loaded
                    
                     try await appState.subscribeToIsos()
                } catch {
                    print(error)
                }
            }
        }
        .sheet(item: $selectedIso) { iso in
            DetailsView(iso: iso)
                .padding()
                .presentationBackground(GridStatusColor.dashboardBackground.color(scheme: colorScheme))
                .presentationDragIndicator(.visible)
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
