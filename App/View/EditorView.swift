import SwiftUI
import SwiftData

struct EditorView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    let note: Note

    @State private var draft = ""
    @State private var autosave: Autosave?
    @FocusState private var editorFocused: Bool

    private var store: NotesStore { NotesStore(context: context) }

    var body: some View {
        ZStack {
            DS.Color.ground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: DS.Space.s + 2) {
                navBar
                Text(NoteDate.editorHeader(for: note.updatedAt))
                    .font(DS.Font.dateHeader)
                    .foregroundStyle(DS.Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityIdentifier("editor.dateHeader")
                TextEditor(text: $draft)
                    .font(DS.Font.editorBody)
                    .foregroundStyle(DS.Color.ink)
                    .tint(DS.Color.accent)
                    .lineSpacing(DS.Metric.editorLineSpacing)
                    .scrollContentBackground(.hidden)
                    .focused($editorFocused)
                    .accessibilityIdentifier("editor.body")
                    .padding(.horizontal, DS.Space.editorGutter - 5)
            }
            .padding(.top, DS.Space.s)
        }
        .task {
            draft = note.text
            autosave = Autosave { save() }
            if note.isBlank { editorFocused = true }
        }
        .onChange(of: draft) { autosave?.schedule() }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { autosave?.flush() }
        }
        .onDisappear {
            autosave?.flush()
            store.discardIfEmpty(note)
        }
    }

    private var navBar: some View {
        HStack {
            Button {
                close()
            } label: {
                HStack(spacing: DS.Space.xs) {
                    Image(systemName: "chevron.left").font(.system(size: 17, weight: .semibold))
                    Text("Notes").font(DS.Font.navAction)
                }
                .foregroundStyle(DS.Color.accent)
            }
            .frame(minHeight: DS.Metric.minTapTarget)
            .accessibilityIdentifier("editor.back")

            Spacer()

            HStack(spacing: DS.Space.m + 2) {
                ShareLink(item: draft) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 17))
                        .foregroundStyle(DS.Color.accent)
                }
                .disabled(draft.isEmpty)
                .accessibilityIdentifier("editor.share")

                Button("Done") { close() }
                    .font(DS.Font.navActionStrong)
                    .foregroundStyle(DS.Color.accent)
                    .accessibilityIdentifier("editor.done")
            }
            .frame(minHeight: DS.Metric.minTapTarget)
        }
        .padding(.horizontal, DS.Space.gutter)
    }

    private func save() {
        store.update(note, text: draft)
    }

    private func close() {
        autosave?.flush()
        editorFocused = false
        dismiss()
    }
}
