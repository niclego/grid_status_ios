import SwiftUI

enum GridStatusColor {
    case batteries
    case biomass
    case coal
    case dataText
    case dashboardBackground
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
        case .dataText:
            return Color.secondary
        case .dashboardBackground:
            return Color(red: 33/255, green: 33/255, blue: 34/255)
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
            return Color.primary
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
        case .dataText:
            return Color(red: 62/255, green: 75/255, blue: 93/255)
        case .dashboardBackground:
            return Color(red: 239/255, green: 243/255, blue: 248/255)
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
            return Color(red: 89/255, green: 105/255, blue: 127/255)
        case .time:
            return Color(red: 96/255, green: 103/255, blue: 116/255)
        case .title:
            return Color(red: 48/255, green: 57/255, blue: 71/255)
        case .wind:
            return Color(red: 1, green: 2, blue: 3)
        }
    }
}
