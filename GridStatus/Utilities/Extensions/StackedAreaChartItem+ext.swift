import Core
import GridStatusCommonUI

extension StackedAreaChartItem {
    init(_ data: StandardFiveMinute) {
        self.init(
            startUtc: data.startUTC,
            batteries: data.batteries,
            biomass: data.biomass,
            coal: data.coal,
            coalAndLignite: data.coalAndLignite,
            duelFuel: data.duelFuel,
            geothermal: data.geothermal,
            imports: data.imports,
            gas: data.gas,
            hydro: data.hydro,
            largeHydro: data.largeHydro,
            naturalGas: data.naturalGas,
            nuclear: data.nuclear,
            oil: data.oil,
            other: data.oil,
            btmSolar: data.btmSolar,
            solar: data.solar,
            wind: data.wind
        )
    }
}
