import SwiftUI

struct UndoToastView: View {
    let undo: () -> Void

    var body: some View {
        HStack(spacing: DS.Space.m) {
            Text("Note deleted")
                .font(DS.Font.rowMeta)
                .foregroundStyle(DS.Color.ink)
            Button("Undo", action: undo)
                .font(DS.Font.navActionStrong)
                .foregroundStyle(DS.Color.accent)
                .accessibilityIdentifier("list.undoButton")
        }
        .padding(.horizontal, DS.Space.m)
        .frame(minHeight: DS.Metric.minTapTarget)
        .background(DS.Color.surface, in: Capsule())
        .shadow(color: DS.Shadow.fabColor, radius: DS.Shadow.fabRadius, y: DS.Shadow.fabY)
        .accessibilityIdentifier("list.undoToast")
    }
}
