import SwiftUI

struct DetailsCardDataLabelText: View {
    let value: String

    var body: some View {
        Text(value)
            .font(.headline)
            .fontWeight(.medium)
            .foregroundColor(.primary)
    }
}
