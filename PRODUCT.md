# Slate

One page. If it doesn't fit here, the idea isn't ready to build.

## What it is

A minimal, fast notes app in the spirit of Apple Notes stripped to its
essence: open → write → done. Typography-forward, no chrome, no accounts,
everything on-device.

## Who it's for

People who reach for a notes app twenty times a day and want zero friction
and zero clutter — and are quietly annoyed that "simple" notes apps keep
growing folders, checklists, and AI buttons.

## Core loop

1. Open the app → land in the notes list, most recent first; one tap starts
   a new note.
2. Write — plain text, autosaved continuously, title inferred from the
   first line.
3. Find it again — instant full-text search; pin the few notes that matter.

Create, persist, retrieve. All three must survive relaunch, from day one.

## Design

Approved screen designs live in `design/` (canvas: list, editor, search,
first launch, dark variants). Direction: quiet paper minimalism — warm
off-white ground, near-black ink, one slate-blue accent reserved for
actions, system SF type, hairline separators, no chrome beyond the pencil
button. Tokens in `App/DesignSystem.swift` implement this palette.

## Monetization

v1 is free. A later one-time "Slate Pro" unlock (~$2.99) may cover: note
locking, plain-text/markdown export, app icon and typeface choices.
Revenue is not the pilot's goal; proving the idea→TestFlight loop is.

## v1.1 (first post-TestFlight release)

Enable the factory's Supabase kit: account via Sign in with Apple + note
sync (local-first — SwiftData stays the offline source of truth), with
account deletion and export in the same release.

## Non-goals (v1)

Folders/tags, sync/iCloud, rich text and attachments, collaboration,
widgets, Apple Pencil. Each can be a later queue row; none blocks shipping.

## Definition of done for v1

- Core loop works end to end with real user data, persists across relaunch.
- Pin, swipe-to-delete with undo, full-text search.
- Empty/loading/error states; dark mode readable (per design/ dark boards).
- Unit tests on search/persistence logic; UI test on the core loop;
  accessibility identifiers on every interactive element.
- App icon, display name, privacy manifest.
