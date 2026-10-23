# Expo Floor Manager

Mobile-friendly PWA for the Hack Your Health 2026 Wellness Expo. The supplied floor-layout PDF is used as the base map, with booth buttons positioned over the source drawing. The supplied vendor list is loaded in `app.js`; blank contact fields are intentional.

## Run locally

Serve this folder with any static web server and open the resulting URL on desktop, iPadOS, or iOS. Netlify can deploy it directly with the included `netlify.toml`.

## Supabase setup

1. Run `supabase/setup.sql` once in the Supabase SQL Editor.
2. Set `supabaseUrl` and `supabasePublishableKey` in `config.js`.
3. In Supabase Auth URL Configuration, set the Site URL to the production Netlify URL.

Authenticated users receive realtime data. Viewer accounts are read-only; Manager and Admin accounts may edit. Only Admin accounts may delete or change roles. Do not place a secret or service-role key in this client.

## Data validation

- 65 vendor records loaded.
- Duplicate source assignments preserved and flagged: booth 302 appears twice for Dreamwalkerz; booth 511 appears twice for The Better Brain Company.
- No names or phone numbers were invented. Unprovided contact fields remain blank.
