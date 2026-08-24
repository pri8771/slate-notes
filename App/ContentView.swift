import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: DS.Space.m) {
            Text("Slate")
                .font(DS.Font.title)
                .foregroundStyle(DS.Color.textPrimary)
                .accessibilityIdentifier("home.title")
            Text("Replace this screen with the core loop from PRODUCT.md.")
                .font(DS.Font.body)
                .foregroundStyle(DS.Color.textSecondary)
                .accessibilityIdentifier("home.placeholder")
        }
        .padding(DS.Space.l)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DS.Color.background)
    }
}

#Preview {
    ContentView()
}
