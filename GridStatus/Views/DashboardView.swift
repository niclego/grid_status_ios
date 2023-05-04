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
        NavigationStack(path: $presentedNumbers) {
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
                    ISOCardList(isos: appState.isos) { isoIndex in
                        presentedNumbers.append(isoIndex)
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
            .navigationDestination(for: Int.self) { i in
                DetailsView(isoId: appState.isos[i].id)
                    .padding()
                    .presentationBackground(GridStatusColor.dashboardBackground.color(scheme: colorScheme))
                    .presentationDragIndicator(.visible)
            }
        }
        .onAppear {
            loadingState = .loading
            Task {
                try await appState.fetchIsos()
                loadingState = .loaded
                try await appState.subscribeToIsos()
            }
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
