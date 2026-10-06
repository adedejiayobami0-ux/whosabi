# WhoSabi — Lagos web app

A mobile-friendly Next.js app prepared for GitHub, Supabase and Vercel. The existing WhoSabi preview is a separate deployment; this package is the portable version.

## Included

- Lagos home search, area/bedroom/total-budget filters and saved homes.
- Itemized annual rent, agency, legal, caution and service charges.
- Separate building and landlord reviews.
- Renter and landlord views of the same demo tenancy.
- Maintenance lifecycle: submitted → viewed → assigned → in progress → awaiting tenant confirmation → resolved.
- Sample repair providers and recommendations.
- Idempotent demo rent/utility payments and downloadable text receipts.
- Supabase email/password accounts; account-owned records across devices.

**This is still a demo, with real account authentication.** The listings, provider profiles, recommendations, landlord identities and tenancy are samples. Reviews are not verified. No money moves. Switching to the Landlord tab is a demo role switch, not real landlord authorization. Do not use it to collect real rent.

## 1. Supabase

Use a dedicated WhoSabi project. Do not overwrite an unrelated existing app.

1. Open the project SQL Editor and run `supabase/schema.sql` once. It creates `whosabi_workspaces` with owner-only row-level security.
2. In the project's Connect dialog, copy the Project URL and **publishable key**. No service-role or secret key is needed.
3. Under Authentication → URL Configuration, set Site URL to your Vercel URL and add these allowed redirect URLs:
   - `http://localhost:3000/auth/callback` for development
   - `https://YOUR-VERCEL-DOMAIN/auth/callback` for deployment
4. Keep email confirmation enabled. Configure authentication email delivery for your intended audience. Supabase's built-in email service has restrictions; use your own SMTP provider before inviting the public.

Create `.env.local` using `.env.example` and fill both values:

```
NEXT_PUBLIC_SUPABASE_URL=https://YOUR-PROJECT.supabase.co
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=YOUR-PUBLISHABLE-KEY
```

Never commit `.env.local`. The publishable key is intended for client use; RLS enforces data access.

## 2. Run locally

Requires Node.js 22.13 or newer.

```
npm ci
npm run dev
```

Open http://localhost:3000. Create an account, confirm the email, then sign in. First sign-in creates a private sample workspace. Existing saved records from the Sites preview are not automatically transferred to this separate Supabase database.

If you see a missing-configuration message, set both environment variables and restart the app. If workspace storage is not ready, run the SQL setup first.

## 3. GitHub

Create a new empty repository, then upload the **contents inside this folder**, including `package.json`, `package-lock.json`, `app`, `lib`, `public`, `supabase` and `.env.example`. `package.json` must be at the repository root.

Alternatively, from this folder:

```
git init
git add .
git commit -m "Prepare WhoSabi for Supabase and Vercel"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/whosabi.git
git push -u origin main
```

Do not upload `node_modules`, `.next`, or `.env.local`.

## 4. Vercel

Import the GitHub repository, select Next.js, keep the repository root as the root directory, and select Node.js 22.x or newer. Add both environment variables above for Production (and Preview if you want preview deployments). Deploy. Then update the Supabase Site URL and callback allowlist to match your actual Vercel domain.

No Cloudflare or Sites-specific runtime is needed for this version.

## Verification

TypeScript and a production Next.js build passed. The SQL schema and owner-only RLS policies were tested in local PostgreSQL-compatible execution, including cross-user access and ownership reassignment attempts. Supabase authentication and live RLS must still be smoke-tested against the selected project after configuration:

1. Create two confirmed accounts A and B.
2. In A, save a home, write a review, submit a repair, and record a demo payment.
3. Reload and sign into A in another browser. Confirm the records persist.
4. Sign into B. Confirm none of A's changes appear.
5. Attempt to read/update A's `user_id` with B's authenticated Supabase client. RLS must return no rows / deny writes.
6. Repeat the same demo bill payment; only one receipt should exist.
7. Move a ticket through the Landlord view and confirm the repair in the Renter view.

## Before opening contributions to Lagos residents

Build shared property records, separate landlord/tenant memberships, listing permission checks, moderation, review reporting, tenancy verification, private document storage and upload controls. The current account-owned demo table is deliberately not a public marketplace schema. Real payments require payment-provider integration, verified webhook processing and a transaction ledger.

## Photos

The three apartment photos are credited to Superite Africa and are illustrative demo assets, not evidence that these fictional properties are available. Replace them with contributor-owned or licensed photos before publishing real listings.
