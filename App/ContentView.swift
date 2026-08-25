import SwiftUI

/// Routes the app's three honest states. The "Slate" title with the
/// `home.title` identifier renders in every state, so the smoke test is a
/// state-independent check rather than a coupling to one screen.
struct ContentView: View {
    @State private var model = AppModel()

    var body: some View {
        Group {
            switch model.phase {
            case .loading:
                titledFallback { LoadingStateView() }
            case .failed(let message):
                titledFallback { ErrorStateView(message: message) { model.retry() } }
            case .ready(let container):
                NotesListView()
                    .modelContainer(container)
            }
        }
        .task { model.start() }
    }

    private func titledFallback<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack {
            DS.Color.ground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: DS.Space.m) {
                Text("Slate")
                    .font(DS.Font.screenTitle)
                    .foregroundStyle(DS.Color.ink)
                    .accessibilityIdentifier("home.title")
                    .padding(.horizontal, DS.Space.gutter)
                content()
            }
            .padding(.top, DS.Space.s)
        }
    }
}
