import SwiftUI

enum GridStatusColor {
    case batteries
    case biomass
    case coal
    case geothermal
    case imports
    case largeHydro
    case naturalGas
    case nuclear
    case other
    case solar
    case subtitle
    case time
    case title
    case wind
    
    func color(scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return ltColor()
        case .dark:
            return dtColor()
        @unknown default:
            return ltColor()
        }
    }
    
    private func dtColor() -> Color {
        switch self {
        case .batteries:
            return Color(red: 1, green: 2, blue: 3)
        case .biomass:
            return Color(red: 1, green: 2, blue: 3)
        case .coal:
            return Color(red: 1, green: 2, blue: 3)
        case .geothermal:
            return Color(red: 1, green: 2, blue: 3)
        case .imports:
            return Color(red: 1, green: 2, blue: 3)
        case .largeHydro:
            return Color(red: 1, green: 2, blue: 3)
        case .naturalGas:
            return Color(red: 1, green: 2, blue: 3)
        case .nuclear:
            return Color(red: 1, green: 2, blue: 3)
        case .other:
            return Color(red: 1, green: 2, blue: 3)
        case .solar:
            return Color(red: 1, green: 2, blue: 3)
        case .subtitle:
            return Color.secondary
        case .time:
            return Color.secondary
        case .title:
            return Color.primary
        case .wind:
            return Color(red: 1, green: 2, blue: 3)
        }
    }
    
    private func ltColor() -> Color {
        switch self {
        case .batteries:
            return Color(red: 1, green: 2, blue: 3)
        case .biomass:
            return Color(red: 1, green: 2, blue: 3)
        case .coal:
            return Color(red: 1, green: 2, blue: 3)
        case .geothermal:
            return Color(red: 1, green: 2, blue: 3)
        case .imports:
            return Color(red: 1, green: 2, blue: 3)
        case .largeHydro:
            return Color(red: 1, green: 2, blue: 3)
        case .naturalGas:
            return Color(red: 1, green: 2, blue: 3)
        case .nuclear:
            return Color(red: 1, green: 2, blue: 3)
        case .other:
            return Color(red: 1, green: 2, blue: 3)
        case .solar:
            return Color(red: 1, green: 2, blue: 3)
        case .subtitle:
            return Color.secondary
        case .time:
            return Color.secondary
        case .title:
            return Color.primary
        case .wind:
            return Color(red: 1, green: 2, blue: 3)
        }
    }
}
