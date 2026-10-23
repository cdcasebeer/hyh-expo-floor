# Expo Floor Manager

Mobile-friendly PWA for the Hack Your Health 2026 Wellness Expo. The supplied floor-layout PDF is used as the base map, with booth buttons positioned over the source drawing. The supplied vendor list is loaded in `app.js`; blank contact fields are intentional.

## Run locally

Serve this folder with any static web server and open the resulting URL on desktop, iPadOS, or iOS. Netlify can deploy it directly with the included `netlify.toml`.

## Supabase setup

1. Set `supabaseUrl` and `supabaseAnonKey` in `config.js`.
2. Create a `vendors` table with `id text primary key`, `name text`, `booths text[]`, `contact text`, and `phone text`.
3. Enable Row Level Security and Realtime for `vendors`, then add policies for your organization.

With credentials present, the app reads the table, upserts edits, and subscribes to realtime changes. Do not place a service-role key in this client. The UI role selector provides Viewer, Manager, and Admin modes; Viewer is read-only.

## Data validation

- 65 vendor records loaded.
- Duplicate source assignments preserved and flagged: booth 302 appears twice for Dreamwalkerz; booth 511 appears twice for The Better Brain Company.
- No names or phone numbers were invented. Unprovided contact fields remain blank.
