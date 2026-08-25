# Queue

One row = one bounded unit finishable in one session. Statuses: planned ·
ready · in_progress · code_complete · verification_pending · verified ·
human_review_required · done · blocked (+ precise unblock action).
Roles: builder · reviewer · qa · owner.

| id | status | role | task |
|---|---|---|---|
| S-001 | verification_pending |  builder | Verify template instantiation: `xcodegen generate` + first CI green on the macOS runner (build + smoke tests). Report SHA to factory registry. |
| S-002 | verification_pending |  builder | Data layer: SwiftData `Note` model (text, createdAt, updatedAt, pinned), NotesStore with create/update/delete/pin + autosave; unit tests for persistence across store reloads. |
| S-003 | verification_pending |  builder | Notes list per design/Main: sections (Pinned/Notes), row = inferred title + date + snippet, hairline separators, note count footer, pencil FAB. Empty state per design/Empty. |
| S-004 | verification_pending |  builder | Editor per design/Editor: open on tap or FAB, first line = title (bold), continuous autosave, Done dismisses, date header. |
| S-005 | verification_pending |  builder | Search per design/Search: live full-text over titles+bodies, match highlighting, result count, cancel restores list. Unit tests on the search logic. |
| S-006 | verification_pending |  builder | Swipe-to-delete with undo; pin/unpin via swipe or context menu per design. |
| S-007 | verification_pending |  builder | DesignSystem tokens = design palette (paper #F7F6F3, ink, slate accent #4E5D78, dark variants); dark mode audit against design/DarkList + DarkEditor. |
| S-008 | verification_pending |  qa | UI test: core loop end to end (create → write → relaunch → find via search → pin → delete+undo). Accessibility identifier audit. |
| S-009 | planned | reviewer | Full review pass against CLAUDE.md + PRODUCT.md; findings become new rows. |
| S-010 | verification_pending |  builder | App icon (slate square, minimal glyph), display name, privacy manifest (no tracking, no network). |
| S-011 | blocked (owner: ASC secrets) | owner | Add ASC API key secrets; then trigger release.yml → first TestFlight build. |
| S-012 | planned (v1.1, after S-011 ships) | owner+agent | Enable Supabase kit: owner creates the Slate Supabase project; builder activates SPM/config, writes notes schema + RLS, implements Sign in with Apple + local-first sync + account deletion/export. |
| S-013 | planned | builder | Editor title typography: the board shows the first line at 26pt/700 inside the editor; iOS 17 TextEditor cannot style a range and splitting title/body would break the derived-title model. Needs a UITextView/NSAttributedString bridge. |
| S-014 | planned | builder | Search highlight shape: AttributedString paints a hard rectangle; the board has a 3pt radius and 2pt padding. Needs a custom text layout. |
