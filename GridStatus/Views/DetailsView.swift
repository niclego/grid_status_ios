import GridStatusCommonUI
import SwiftUI

struct DetailsView: View {
    @EnvironmentObject var appState: AppState
    
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
                    
                    if let config = appState.chartConfig {
                        StackedAreaChartCard(config: config, timeZone: Date.timeZoneFor(isoId: iso.id) ?? .current)
                            .frame(height: 500)
                    } else {
                        LoadingCard()
                    }
                    
                    Spacer()
                    
                    // Charts Views
                }
                .onAppear {
                    var startTimeUtc: String {
                        let date = Calendar.current.startOfDay(for: Date.now)
                        let newDate = date.convert(from: .current, to: Date.timeZoneFor(isoId: iso.id) ?? .current)
                        print(ISO8601DateFormatter().string(from: newDate))
                        return ISO8601DateFormatter().string(from: newDate)
                    }
                    
                    var endTimeUtc: String {
                        let date = Calendar.current.startOfDay(for: Date.now)
                        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                        let newDate = nextDate.convert(from: .current, to: Date.timeZoneFor(isoId: iso.id) ?? .current)
                        print(ISO8601DateFormatter().string(from: newDate))
                        return ISO8601DateFormatter().string(from: newDate)
                    }

                    Task {
                        do {
                            try await appState.fetchFiveMinData(
                                isoId: iso.id,
                                startTimeUtc: startTimeUtc,
                                endTimeUtc: endTimeUtc
                            )
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
        DetailsView(iso: ISOViewItem.example)
            .environmentObject(
                AppState()
            ).padding()
    }
}
