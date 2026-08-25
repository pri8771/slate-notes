import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: DS.Space.m - 2) {
            EmptyNoteGlyph()
            Text("No notes yet")
                .font(DS.Font.emptyTitle)
                .foregroundStyle(DS.Color.ink)
                .accessibilityIdentifier("empty.title")
            Text("Everything you write stays on this phone. Tap the pencil to start.")
                .font(DS.Font.emptyBody)
                .foregroundStyle(DS.Color.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .padding(.horizontal, DS.Space.xl + DS.Space.s)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LoadingStateView: View {
    var body: some View {
        ProgressView()
            .tint(DS.Color.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accessibilityIdentifier("state.loading")
    }
}

struct ErrorStateView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: DS.Space.m) {
            Text(message)
                .font(DS.Font.emptyTitle)
                .foregroundStyle(DS.Color.ink)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("error.message")
            Text("Your notes are still on this phone. Try opening them again.")
                .font(DS.Font.emptyBody)
                .foregroundStyle(DS.Color.secondary)
                .multilineTextAlignment(.center)
            Button("Try Again", action: retry)
                .font(DS.Font.navActionStrong)
                .foregroundStyle(DS.Color.accent)
                .frame(minHeight: DS.Metric.minTapTarget)
                .accessibilityIdentifier("error.retry")
        }
        .padding(.horizontal, DS.Space.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
