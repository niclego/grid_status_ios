import GridStatusCommonUI
import SwiftUI

struct DetailsView: View {
    @EnvironmentObject var appState: AppState
    
    let isoId: String

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    if let iso = appState.isos.first(where: { $0.id == isoId }) {
                        ISODetailsCard(iso: iso)
                    } else {
                        LoadingCard()
                    }
                    
                    if let config = appState.chartConfig {
                        StackedAreaChartCard(config: config)
                            .frame(height: 500)
                    } else {
                        LoadingCard()
                    }
                    
                    Spacer()
                    
                    // Charts Views
                }
                .onAppear {
                    Task {
                        do {
                            try await appState.fetchFiveMinData(isoId: isoId)
                        } catch {
                            print(error)
                        }
                    }
                }
                .onDisappear {
                    print("see ya")
                    appState.clear()
                }
            }
        }

    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(isoId: ISOViewItem.example.id)
            .environmentObject(
                AppState()
            ).padding()
    }
}
