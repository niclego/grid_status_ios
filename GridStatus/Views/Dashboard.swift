// https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-programmatic-navigation-in-swiftui

import SwiftUI

struct Dashboard: View {
    @StateObject var vm: ViewModel

    var body: some View {
        LoadableContent.ContainerView(loadingState: vm.loadingState) {
            Text("The was an error while connecting to Gridstatus.io")
            Button("Retry", action: vm.subscribe)
                .buttonStyle(.borderedProminent)
        } content: {
            List {
                ForEach(vm.isos, id: \.iso) { iso in
                    Button(action: {
                        vm.selectedIso = iso
                    }) {
                        DetailsCard(iso: iso)
                    }
                }
            }
        }
        .onAppear {
            vm.subscribe()
        }
        .sheet(item: $vm.selectedIso, content: { iso in
            ChartsContainer(iso: iso).padding()
        })
        .environmentObject(vm)
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(
            vm: ViewModel(
                networkManager: NetworkManagerMock(),
                sleeper: Sleeper(durationInSeconds: 1)
            )
        )
    }
}
