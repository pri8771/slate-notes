import SwiftUI
import SwiftData

struct NotesListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Note.updatedAt, order: .reverse) private var notes: [Note]

    @State private var query = ""
    @State private var editing: Note?
    @State private var pendingUndo: NoteSnapshot?
    @State private var undoTask: Task<Void, Never>?
    @FocusState private var searchFocused: Bool

    private var store: NotesStore { NotesStore(context: context) }
    private var pinned: [Note] { notes.filter(\.isPinned) }
    private var unpinned: [Note] { notes.filter { !$0.isPinned } }
    private var isSearching: Bool {
        searchFocused || !query.trimmingCharacters(in: .whitespaces).isEmpty
    }
    private var results: [SearchResult] {
        NoteSearch.results(
            for: query,
            in: notes.map {
                SearchableNote(id: $0.id, title: $0.displayTitle, body: $0.text)
            }
        )
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            DS.Color.ground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: DS.Space.m - 2) {
                if !isSearching {
                    Text("Slate")
                        .font(DS.Font.screenTitle)
                        .foregroundStyle(DS.Color.ink)
                        .accessibilityIdentifier("home.title")
                }
                searchBar
                content
            }
            .padding(.top, DS.Space.s)

            if pendingUndo != nil {
                UndoToastView(undo: performUndo)
                    .padding(.leading, DS.Space.gutter)
                    .padding(.trailing, DS.Metric.fabSize + DS.Space.gutter * 2)
                    .padding(.bottom, DS.Metric.fabBottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity)
            }

            if !isSearching {
                PencilFAB(action: newNote)
                    .padding(.trailing, DS.Metric.fabTrailing)
                    .padding(.bottom, DS.Metric.fabBottom)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: pendingUndo)
        .fullScreenCover(item: $editing) { note in
            EditorView(note: note)
        }
    }

    private var searchBar: some View {
        HStack(spacing: DS.Space.m - 4) {
            SearchPill(text: $query, isFocused: $searchFocused)
            if isSearching {
                Button("Cancel") {
                    query = ""
                    searchFocused = false
                }
                .font(DS.Font.searchField)
                .foregroundStyle(DS.Color.accent)
                .accessibilityIdentifier("search.cancel")
            }
        }
        .padding(.horizontal, DS.Space.gutter)
    }

    @ViewBuilder
    private var content: some View {
        if isSearching {
            searchResults
        } else if notes.isEmpty {
            EmptyStateView()
        } else {
            notesList
        }
    }

    private var searchResults: some View {
        Group {
            if results.isEmpty {
                VStack(spacing: DS.Space.s) {
                    Text("No matches")
                        .font(DS.Font.emptyTitle)
                        .foregroundStyle(DS.Color.ink)
                    Text("Try a different word.")
                        .font(DS.Font.emptyBody)
                        .foregroundStyle(DS.Color.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityIdentifier("search.noMatches")
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        sectionHeader(NoteText.countLabel(results.count).replacingOccurrences(of: "note", with: "result"))
                            .accessibilityIdentifier("search.resultsHeader")
                        ForEach(Array(results.enumerated()), id: \.element.id) { index, result in
                            SearchResultRow(result: result, isLast: index == results.count - 1)
                                .onTapGesture { openSearchResult(result) }
                        }
                    }
                    .padding(.horizontal, DS.Space.gutter)
                }
                .padding(.top, DS.Space.xs)
            }
        }
    }

    private var notesList: some View {
        List {
            if !pinned.isEmpty {
                Section {
                    rows(for: pinned)
                } header: {
                    HStack(spacing: DS.Space.xs + 2) {
                        Image(systemName: "star")
                            .font(.system(size: 11))
                            .foregroundStyle(DS.Color.secondary)
                        sectionHeader("Pinned")
                    }
                }
            }
            if !unpinned.isEmpty {
                Section {
                    rows(for: unpinned)
                } header: {
                    sectionHeader("Notes")
                }
            }
            Text(NoteText.countLabel(notes.count))
                .font(DS.Font.footer)
                .foregroundStyle(DS.Color.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, DS.Space.l)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .accessibilityIdentifier("list.footer")
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .environment(\.defaultMinListRowHeight, 0)
    }

    private func rows(for group: [Note]) -> some View {
        ForEach(Array(group.enumerated()), id: \.element.id) { index, note in
            NoteRowView(note: note, isLast: index == group.count - 1)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: DS.Space.gutter,
                                          bottom: 0, trailing: DS.Space.gutter))
                .onTapGesture { editing = note }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) { delete(note) } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button { store.setPinned(note, !note.isPinned) } label: {
                        Label(note.isPinned ? "Unpin" : "Pin", systemImage: "star")
                    }
                    .tint(DS.Color.accent)
                }
                // Context menu mirrors the swipe actions: discoverable, and
                // far more reliable to drive from UI tests than a swipe.
                .contextMenu {
                    Button(note.isPinned ? "Unpin" : "Pin") {
                        store.setPinned(note, !note.isPinned)
                    }
                    .accessibilityIdentifier("row.pin")
                    Button("Delete", role: .destructive) { delete(note) }
                        .accessibilityIdentifier("row.delete")
                }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(DS.Font.sectionHeader)
            .tracking(DS.Metric.sectionTracking)
            .foregroundStyle(DS.Color.secondary)
            .padding(.bottom, DS.Space.s)
    }

    private func newNote() {
        editing = store.create()
    }

    private func openSearchResult(_ result: SearchResult) {
        guard let note = notes.first(where: { $0.id == result.id }) else { return }
        searchFocused = false
        editing = note
    }

    private func delete(_ note: Note) {
        let snapshot = store.delete(note)
        pendingUndo = snapshot
        undoTask?.cancel()
        undoTask = Task {
            try? await Task.sleep(for: .seconds(6))
            guard !Task.isCancelled else { return }
            pendingUndo = nil
        }
    }

    private func performUndo() {
        guard let snapshot = pendingUndo else { return }
        store.restore(snapshot)
        undoTask?.cancel()
        pendingUndo = nil
    }
}

