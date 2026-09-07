---
name: session-verdict
description: >-
  Keep a Capacitor WebView supabase-js session from looking logged-out when
  storage is empty, still warming, or the network failed. Use when a hybrid app
  bounces to login after background resume or OTA, when getSession is empty on
  native cold start, or when a guard treats a fetch error as sign-out. Do not
  use to contest SIGNED_OUT on supabase-js 2.108.2 or newer — upgrade instead.
  Do not use for native Auth via @capgo/capacitor-supabase.
license: MIT
---

# Session Verdict

A missing `getSession()` user is not proof of logout. Neither is a network error. Give every auth guard one resolver that returns `authenticated` | `expired` | `unresolved`, and only redirect to login on `expired`.

Phantom `SIGNED_OUT` from a failed proactive refresh was an SDK bug. It is fixed in [@supabase/supabase-js 2.108.2](https://github.com/supabase/supabase-js/releases/tag/v2.108.2) ([#2436](https://github.com/supabase/supabase-js/pull/2436)). Upgrade first. For Capacitor native Auth, use [`@capgo/capacitor-supabase`](https://capgo.app/docs/plugins/supabase/) instead of this skill.

## Instructions

### Step 1: Upgrade or switch storage

1. If `@supabase/supabase-js` is older than 2.108.2, upgrade. Done when `package.json` is at least that version.
2. If Auth still uses WebView `localStorage`, point `auth.storage` at Capacitor Preferences ([Capacitor storage](https://capacitorjs.com/docs/guides/storage)). iOS reclaims WebView `localStorage`; that looks like logout and is not `SIGNED_OUT`.

Done when the client is on a current supabase-js and tokens live in Preferences on native.

### Step 2: One resolver, three verdicts

Find every listener and route guard that decides the user is logged out. They all call one module:

| Verdict | Meaning | UI |
| --- | --- | --- |
| `authenticated` | Token present and valid (or refresh succeeded) | Stay |
| `unresolved` | Network down, or Preferences still warming (cold start / OTA apply) | Hold the current shell. Do not show login. |
| `expired` | No tokens in durable storage, or refresh definitively failed | Re-auth with `returnTo` |

Do not map `Failed to fetch` (match case-insensitively) or `navigator.onLine === false` to `expired`. While the Preferences bridge is warming, return `unresolved`, not login.

Done when no remaining `if (!session) redirect('/login')`.

### Step 3: Treat `SIGNED_OUT` as cleanup only after upgrade

On current supabase-js, `SIGNED_OUT` means Auth already cleared its storage. Honor an intentional `signOut()` (set a flag before the call; `{ scope: 'local' }` unless you mean every device). Otherwise resolve: no Preferences tokens → `expired`; tokens still warming → `unresolved`.

Do not keep a second token copy that `signOut()` cannot delete. Rehydrating from that copy signs the user back in after a real logout. The access JWT stays valid until `exp` even after client sign-out.

Done when a real Sign out button leaves the user logged out, and a cold start with tokens in Preferences does not flash login.

## Guardrails

- Several guards that each call `getSession()` will disagree. One resolver.
- `getClaims()` verifies signature and `exp`. It does not prove the session was revoked server-side (`getUser()`).
- On supabase-js 2.108.2+, do not invent a contest for phantom `SIGNED_OUT`. Upgrade was the contest.
