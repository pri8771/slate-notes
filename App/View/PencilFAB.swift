import SwiftUI

struct PencilFAB: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(DS.Color.accent)
                PencilGlyph()
            }
            .frame(width: DS.Metric.fabSize, height: DS.Metric.fabSize)
            .shadow(color: DS.Shadow.fabColor,
                    radius: DS.Shadow.fabRadius,
                    y: DS.Shadow.fabY)
        }
        .accessibilityIdentifier("list.fab")
        .accessibilityLabel("New note")
    }
}
