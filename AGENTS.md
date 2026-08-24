# Slate — Operating Rules

This file is the entire rulebook. Read it fully every session. Do not create
additional rule or process documents; if a rule needs to change, change it here
via a small PR. (Codex/other CLIs: `AGENTS.md` is a symlink or copy of this file.)

## What this app is

See `PRODUCT.md` — one page: what, for whom, core loop, monetization. Code
implements PRODUCT.md; neither drifts from the other silently.

## Run protocol (every session, human or agent)

1. Read this file, then `MEMORY.md`, then `HANDOFF.md`.
2. Take the top unblocked row of `QUEUE.md` that matches your role; mark it
   `in_progress` with your name. Never work outside a queue row — if the work
   you intend has no row, add the row first.
3. Do exactly that one bounded unit, on a branch if it is risky.
4. Verify locally what you can (`xcodegen generate` + build/test in the
   simulator when available). Then push. **Nothing exists until it is pushed.**
5. Update `HANDOFF.md` (exact resume point, 1–3 lines), the queue row's
   status, and `MEMORY.md` only if durable facts changed. One atomic commit.
6. If blocked: record the precise blocker and the exact unblock action on the
   row, then take the next unrelated safe row. A blocker stops only itself.

## Roles

Defined in `.claude/agents/` (builder, reviewer, qa). One role per session.
Roles hand off through queue rows — never debate, never vote. A reviewer or QA
session may add rows and flip a row back to `ready` with findings; it may not
rewrite the builder's work in the same session.

## Status vocabulary (use exactly these)

planned · ready · in_progress · code_complete · verification_pending ·
verified · human_review_required · done · blocked (+ precise unblock action)

## The functionality rule (binding, checked before any "done")

Looking done is not being done. A screen that renders but whose controls do
nothing, shows hardcoded data, skips the real calculation, or fails to persist
state the feature implies — is UNMET regardless of visual polish. "Done" means:
real logic runs, real user data flows, state survives navigation and relaunch,
and the primary workflow works end to end in the simulator.

## Engineering rules

- SwiftUI, iOS 17+. Project is generated: edit `project.yml`, run
  `xcodegen generate`; never hand-edit the `.xcodeproj`.
- All colors, fonts, and spacing come from `App/DesignSystem.swift` tokens.
  No inline colors or font sizes anywhere else.
- Every interactive element has an `accessibilityIdentifier`.
- Every screen handles empty, loading, and error states — not just the happy
  path. Dark mode must be readable.
- Unit tests for logic, at least one UI test per primary flow. A change that
  breaks tests is not finished, whatever else it achieves.
- No TODO/FIXME left in pushed source; turn them into queue rows instead.
- Never commit secrets, tokens, API keys, or personal data. Never weaken,
  skip, or delete a test to make CI green.

## Verification and gates

CI (`.github/workflows/ci.yml`) builds and tests every push on a macOS runner.
CI results are the only source of the `build` and `tests` gate states in the
factory registry (`app_factory/apps.json`) — bound to the commit SHA.
You may *request* gate runs; you may never *declare* a gate passed.
`unknown` never passes. Release to TestFlight happens only through
`.github/workflows/release.yml`, triggered by the owner.

## Backend (when the app needs one)

Supabase is the factory's standard backend — accounts, sync, shared data,
storage. Rules:

- Default to on-device (SwiftData) until PRODUCT.md names a feature that
  needs a backend; then use Supabase via the official supabase-swift SDK.
  One Supabase project per app (owner creates it; URL + anon key are
  config, not secrets — but service-role keys NEVER appear in the repo).
- Local-first always: the on-device store stays the source of truth
  offline; Supabase syncs it. No feature may break when the network is gone.
- Row Level Security ON for every table, policies written with the schema.
  Auth = Sign in with Apple through Supabase Auth.
- Schema lives in the repo as `Supabase/schema.sql` (+ migration files) —
  the database is code-reviewed like everything else.
- Account deletion and data export must ship in the same version that
  introduces accounts (App Store requirement and house rule).

## Owner-only actions

Signing/App Store Connect secrets, content/legal sign-off, device-gate
confirmation, TestFlight/App Store submission, and any spending.

## Lessons

When something here proved wrong or a systemic fix emerged, append one line to
the factory's `LESSONS.md`. Improvements land only as PRs to the factory
`template/` — never as new machinery in this repo.
