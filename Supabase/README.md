# Supabase backend kit

Most factory apps will use Supabase. This kit stays dormant until the app's
PRODUCT.md names a backend feature; enabling it is one bounded queue unit.

## Enable (queue row: "Enable Supabase backend")

1. Owner: create the app's Supabase project (one per app, free tier) at
   supabase.com; note the project URL and anon key. Anon key + URL are
   public config; the service-role key is a secret and NEVER enters this
   repo or CI.
2. Builder: uncomment the `packages:` block in `project.yml` (supabase-swift)
   and the `SUPABASE_URL` / `SUPABASE_ANON_KEY` Info.plist settings; run
   `xcodegen generate`.
3. Builder: write the schema in `schema.sql` — every table with RLS enabled
   and policies alongside; apply it via the Supabase SQL editor (or CLI) and
   keep this file as the reviewed source of truth. Migrations append as
   `migrations/NNN_description.sql`.
4. Auth is Sign in with Apple via Supabase Auth. Local-first is binding:
   SwiftData remains the offline source of truth; sync reconciles.
5. Account deletion + data export ship in the same version as accounts.

## Files

- `schema.sql` — full current schema, RLS on, policies included.
- `migrations/` — append-only migration files once the schema is live.
