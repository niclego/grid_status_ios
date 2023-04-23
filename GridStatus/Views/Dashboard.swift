// https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-programmatic-navigation-in-swiftui

import SwiftUI

struct Dashboard: View {
    @StateObject var vm: ViewModel

    var body: some View {
        List {
            ForEach(vm.isos, id: \.iso) { iso in
                Button(action: {
                    vm.selectedIso = iso
                }) {
                    DetailsCard(iso: iso)
                }
            }
        }
        .refreshable {
            await vm.fetchIsos()
        }
        .onAppear {
            Task {
                await vm.fetchIsos()
            }
        }
        .sheet(item: $vm.selectedIso, content: { iso in
            ChartsContainer(iso: iso).padding()
        })
        .environmentObject(vm)
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(vm: ViewModel(networkManager: NetworkManagerMock()))
    }
}
