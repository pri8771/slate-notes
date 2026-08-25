import SwiftUI

struct SearchPill: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding

    var body: some View {
        HStack(spacing: DS.Space.s) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(DS.Color.secondary)
            TextField("Search", text: $text)
                .font(DS.Font.searchField)
                .foregroundStyle(DS.Color.ink)
                .tint(DS.Color.accent)
                .focused(isFocused)
                .autocorrectionDisabled()
                .accessibilityIdentifier("list.searchField")
        }
        .padding(.horizontal, DS.Space.m - 4)
        .padding(.vertical, 9)
        .background(DS.Color.surface, in: RoundedRectangle(cornerRadius: DS.Metric.pillRadius))
    }
}
