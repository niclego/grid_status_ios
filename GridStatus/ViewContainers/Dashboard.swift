// https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-programmatic-navigation-in-swiftui

import grid_status_common_ui
import SwiftUI

struct Dashboard: View {
    @Environment(\.colorScheme) var colorScheme

    @StateObject var vm: ViewModel

    var body: some View {
        VStack {
            HStack {
                Text("Gridstatus.io").font(.title)
                    .foregroundColor(GridStatusColor.dataText.color(scheme: colorScheme))
                    .fontWeight(.bold)
                Spacer()
            }.padding([.top, .leading], 12)
            
            Spacer()
            
            LoadableContent.ContainerView(loadingState: vm.loadingState) {
                VStack {
                    Text("The was an error while connecting to Gridstatus.io")
                    Button("Retry", action: vm.subscribe)
                        .buttonStyle(.bordered)
                }
            } content: {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(vm.isos) { iso in
                            ISODetailsCard(iso: iso)
                                .onTapGesture {
                                    vm.selectedIso = iso
                                }
                        }
                    }
                    .padding(12)
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
        Dashboard(
            vm: ViewModel()
        )
    }
}
