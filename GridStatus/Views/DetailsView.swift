import GridStatusCommonUI
import SwiftUI

struct DetailsView: View {
    @EnvironmentObject var appState: AppState

    @State var datas: [StackedAreaChartItem]

    init(iso: ISOViewItem, datas: [StackedAreaChartItem] = []) {
        self.iso = iso
        self.datas = datas
    }

    let iso: ISOViewItem

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    if let iso = appState.isos.first(where: { $0.id == iso.id }) {
                        ISODetailsCard(iso: iso)
                    } else {
                        LoadingCard()
                    }

                    StackedAreaChartCard (
                        config: .init(isoId: iso.id, dataType: "Fuel Mix", showLegend: true),
                        datas: datas,
                        timeZone: TimeZone.on(isoId: iso.id)
                    )
                    .frame(height: 500)

                    Spacer()
                    
                    // Charts Views
                }
                .onAppear {
                    Task {
                        do {
                            let startEnd = Date.oneDayStartEndDate(
                                for: Date.now,
                                with: TimeZone.on(isoId: iso.id)
                            )

                            self.datas = try await appState.fetchFiveMinData(
                                isoId: iso.id,
                                startTimeUtc: startEnd.start.utcString,
                                endTimeUtc: startEnd.end.utcString
                            )
                        } catch {
                            print(error)
                        }
                    }
                }
                .onDisappear {
                    datas = []
                    print("see ya")
                }
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(
            iso: ISOViewItem.example,
            datas: StandardFiveMinuteResponse.example.data.map { StackedAreaChartItem.init($0) }
        )
            .environmentObject(
                AppState()
            ).padding()
    }
}
