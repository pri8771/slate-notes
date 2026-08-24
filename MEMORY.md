# Slate Memory

Budget: ≤80 lines. Restart index, not a history log.
Updated: 2026-08-24

## Restart in under two minutes

1. Read `CLAUDE.md`, then this file, then `HANDOFF.md`.
2. Take the top unblocked `QUEUE.md` row for your role.
3. One bounded unit → push → update handoff → stop.

## Objective

Ship Slate v1 (minimal on-device notes: list, editor, autosave, search,
pin, delete) to TestFlight. This is the gen-6 factory's pilot app.

## Current critical path

- Repo instantiated from the factory template; design approved and stored
  in `design/`.
- Next: S-001 (first CI green on the macOS runner), then the build loop
  S-002 onward.

## Verified facts (durable, evidence-linked)

- Design canvas approved by owner 2026-08-24 (screens: list, editor,
  search, empty, dark ×2).

## Owner gates outstanding

- ASC API key secrets (for the eventual TestFlight release; does not block
  the build loop).
