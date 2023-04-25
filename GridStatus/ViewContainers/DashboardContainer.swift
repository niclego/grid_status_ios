// https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-programmatic-navigation-in-swiftui

import grid_status_common_ui
import SwiftUI

struct DashboardContainer: View {
    @Environment(\.colorScheme) var colorScheme

    @StateObject var vm: ViewModel

    var body: some View {
        VStack {
            HStack {
                GridStatusHeaderView()
                Spacer()
            }.padding([.top, .leading], 12)
            
            Spacer()
            
            LoadableContent.ContainerView(loadingState: vm.loadingState) {
                ErrorRetryView(retryAction: vm.subscribe)
            } content: {
                ISOCardList(isos: vm.isos) { iso in
                    vm.selectedIso = iso
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(GridStatusColor.dashboardBackground.color(scheme: colorScheme))
        .onAppear {
            vm.subscribe()
        }
        .onDisappear {
            vm.unsubscribe()
        }
        .sheet(item: $vm.selectedIso, content: { iso in
            ChartsContainer(iso: iso)
                .padding()
                .presentationBackground(GridStatusColor.dashboardBackground.color(scheme: colorScheme))
        })
        .environmentObject(vm)
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardContainer(
            vm: ViewModel()
        )
    }
}
