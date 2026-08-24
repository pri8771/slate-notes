# Queue

One row = one bounded unit finishable in one session. Statuses: planned ·
ready · in_progress · code_complete · verification_pending · verified ·
human_review_required · done · blocked (+ precise unblock action).
Roles: builder · reviewer · qa · owner.

| id | status | role | task |
|---|---|---|---|
| S-001 | ready | builder | Verify template instantiation: `xcodegen generate` + first CI green on the macOS runner (build + smoke tests). Report SHA to factory registry. |
| S-002 | ready (after S-001) | builder | Data layer: SwiftData `Note` model (text, createdAt, updatedAt, pinned), NotesStore with create/update/delete/pin + autosave; unit tests for persistence across store reloads. |
| S-003 | planned | builder | Notes list per design/Main: sections (Pinned/Notes), row = inferred title + date + snippet, hairline separators, note count footer, pencil FAB. Empty state per design/Empty. |
| S-004 | planned | builder | Editor per design/Editor: open on tap or FAB, first line = title (bold), continuous autosave, Done dismisses, date header. |
| S-005 | planned | builder | Search per design/Search: live full-text over titles+bodies, match highlighting, result count, cancel restores list. Unit tests on the search logic. |
| S-006 | planned | builder | Swipe-to-delete with undo; pin/unpin via swipe or context menu per design. |
| S-007 | planned | builder | DesignSystem tokens = design palette (paper #F7F6F3, ink, slate accent #4E5D78, dark variants); dark mode audit against design/DarkList + DarkEditor. |
| S-008 | planned | qa | UI test: core loop end to end (create → write → relaunch → find via search → pin → delete+undo). Accessibility identifier audit. |
| S-009 | planned | reviewer | Full review pass against CLAUDE.md + PRODUCT.md; findings become new rows. |
| S-010 | planned | builder | App icon (slate square, minimal glyph), display name, privacy manifest (no tracking, no network). |
| S-011 | blocked (owner: ASC secrets) | owner | Add ASC API key secrets; then trigger release.yml → first TestFlight build. |
| S-012 | planned (v1.1, after S-011 ships) | owner+agent | Enable Supabase kit: owner creates the Slate Supabase project; builder activates SPM/config, writes notes schema + RLS, implements Sign in with Apple + local-first sync + account deletion/export. |
