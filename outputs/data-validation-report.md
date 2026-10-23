# Expo Floor Manager data validation

Source files reviewed: `Wellness Expo Booth List.pdf` and `espo floor layout.pdf` from the referenced conversation.

- 65 vendor records loaded.
- Duplicate source assignments: booth 302 appears twice for Dreamwalkerz; booth 511 appears twice for The Better Brain Company.
- Duplicate assignments are preserved in the app and visibly flagged.
- Contact names and phone numbers were not present in the supplied booth list, so those fields remain blank.
- The supplied floor layout is used as the map background; booth controls are overlaid at the corresponding map positions.
- Source reference retained in the app: https://homebase.map-dynamics.com/hackyourhealth2026/floorplan

## Verification

- JavaScript syntax checks passed with the bundled Node.js runtime.
- Browser preview loaded successfully and displayed all 65 booth records.
- Search filtered to Dreamwalkerz and showed both source booth entries.
- Validation tab displayed the duplicate warnings and source notes.
- Viewer mode is read-only; Manager/Admin modes expose editing.
