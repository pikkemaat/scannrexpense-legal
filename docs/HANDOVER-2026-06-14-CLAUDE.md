# Handover — ScannrExpense Legal & Support

- **Date:** 2026-06-14
- **Branch:** `claude/handover-docs-neskmq`
- **Repository:** `pikkemaat/scannrexpense-legal`

## Purpose of this repository

This repo hosts the **public legal and support pages** for the ScannrExpense
iOS app. The app helps users scan, organize, and export receipt and expense
information on iPhone, with optional iCloud sync and Apple StoreKit
subscriptions. These documents are referenced from the App Store listing and
from inside the app, so the published URLs must remain stable.

## Current contents

| File | Purpose |
| --- | --- |
| `README.md` | Index page linking to the legal/support documents. |
| `PRIVACY_POLICY.md` | Privacy policy (last updated 2026-05-17). |
| `TERMS_OF_USE.md` | Terms of use (last updated 2026-05-17). |
| `SUPPORT.md` | Support instructions and common checks. |
| `docs/HANDOVER-2026-06-14-CLAUDE.md` | This handover document. |

## Key facts

- **Support / contact email:** `165699@skane.se` (used in the privacy policy,
  terms of use, and support page). Keep this consistent across all files if it
  ever changes.
- **Last legal update:** 2026-05-17. Bump the `Last updated:` line in
  `PRIVACY_POLICY.md` and `TERMS_OF_USE.md` whenever their content changes.
- **Platform specifics:** Data is stored on-device and synced via the user's
  personal iCloud account (Apple-provided). Subscriptions are auto-renewable
  in-app purchases handled by Apple/StoreKit. No advertising tracking; no sale
  of personal data.
- These pages are plain Markdown with no build step, CI, or tooling. They are
  intended to render directly (e.g. via GitHub Pages or raw Markdown viewing).

## Conventions for future edits

1. **Keep URLs stable.** App Store and in-app links may point at these files;
   avoid renaming or moving them without updating the consumers.
2. **Update the date.** Any change to legal text should bump the
   `Last updated:` date in the affected file.
3. **Keep the contact email in sync** across all four content files.
4. **Match the existing tone** — concise, plain-language, user-facing. These
   are read by end users and App Store reviewers, not developers.
5. **Update the README index** if a new legal/support document is added.

## State at handover

- Working tree clean; only commit on `main` is `c0dc512 Add ScannrExpense
  public legal pages`.
- No open work in progress beyond this handover document.

## Suggested next steps (if continuing)

- Confirm whether these pages are published via GitHub Pages and verify the
  live URLs match what the App Store listing and app reference.
- Consider adding a short "Account & data deletion" section to the privacy
  policy if Apple guidelines require an explicit data-deletion statement.
