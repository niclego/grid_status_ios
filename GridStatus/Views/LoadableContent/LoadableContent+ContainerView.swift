import SwiftUI

enum LoadableContent {}

extension LoadableContent {
    enum LoadingState {
        case error(error: Error)
        case loaded
        case loading
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
            }
        }
    }
}
