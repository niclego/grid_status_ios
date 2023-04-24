import SwiftUI

enum LoadableContent {}

extension LoadableContent {
    enum LoadingState: Equatable {
        static func == (lhs: LoadableContent.LoadingState, rhs: LoadableContent.LoadingState) -> Bool {
            switch (lhs, rhs) {
            case(.error, .error):
                return true
            case(.loaded, .loaded):
                return true
            case(.loading, .loading):
                return true
            case (.noData, .noData):
                return true
            default:
                return false
            }
        }
        
        case error
        case loaded
        case loading
        case noData
    }
}

extension LoadableContent {
    struct ContainerView<ContentView: View, ErrorView: View>: View {
        let loadingState: LoadingState
        let errorContent: () -> ErrorView
        let content: () -> ContentView
        
        init(
            loadingState: LoadingState,
            @ViewBuilder errorContent: @escaping () -> ErrorView,
            @ViewBuilder content: @escaping () -> ContentView
        ) {
            self.loadingState = loadingState
            self.errorContent = errorContent
            self.content = content
        }
        
        var body: some View {
            switch loadingState {
            case .error:
                errorContent()
            case .loaded:
                content()
            case .loading:
                Text("Loading...")
            case .noData:
                Text("No data")
            }
        }
    }
}
