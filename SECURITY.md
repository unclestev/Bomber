# Security

The most important rule in Bomber: **a player's Nostr private key must never be exposed.** This file explains how the game keeps to that and what each part is trusted to do.

## Players' keys

- **Bomber never handles private keys.** There is no field for an `nsec`, no "create account" key generator and no key import. All signing happens inside a NIP-07 browser extension or a NIP-46 signer app, which keep the key and ask the player before signing.
- **Paste guard.** If anything that looks like a private key (`nsec1…`, `ncryptsec1…`, or 64 hex characters) is typed or pasted into the one text box Bomber has (the `bunker://` field), it is cleared immediately, a warning is shown, and it is never stored or sent.
- **Narrow requests.** Bomber only asks signers to sign:
  - kind **27235** (NIP-98 HTTP auth) to prove to the referee that a run is yours. Bound to the exact URL, method and body hash; valid for two minutes; never published.
  - kind **1** only when you tap Share, after showing you the exact text.
  Signer-app connections request only `sign_event:27235,sign_event:1`.
- **Checked results.** Every event a signer returns is checked before use: valid signature, the signed-in pubkey, and exactly the kind, tags and content Bomber asked for.
- **Session keys.** Nostr Connect needs a throwaway session key for the encrypted channel to the signer app. Bomber creates it in memory for that visit only and never writes it to storage. It cannot sign as you, and it is gone when you reload. You reconnect your signer app on the next visit.
- **What is stored.** `localStorage` holds settings, local high scores, and `bomber.nostr = { method, pubkey }` — public information only.

## The page

- **Strict Content Security Policy.** Only Bomber's own script files can run: no inline scripts, no `eval`, no third-party JavaScript. Trusted Types are enforced, so HTML can't be injected from strings. Network access is limited to Nostr relays (`wss:`) and the referee.
- **No CDN code.** The Nostr library is a pinned, vendored build of nostr-tools v2.25.2 and its audited `@noble`/`@scure` dependencies (`tools/build-vendor.sh` rebuilds it from release tags).
- **Untrusted relay data.** Profile names and pictures from relays are length-limited, stripped of control and direction-override characters, and displayed with `textContent`. Pictures must be `https:` and load with no referrer.
- **Clickjacking guard.** If Bomber is embedded inside another site, sign-in and signing are disabled.

## The referee

- Runs as a Cloudflare Worker. Its Nostr private key exists only in the `REFEREE_SECRET` Worker secret. The setup page shows the public key, never the secret.
- Tickets are sealed with an HMAC derived from that secret, bound to one player and one mode, and expire after six hours. The referee keeps no database.
- `/verify` requires a valid NIP-98 signature from the ticket's player, replays the full run with `js/sim.js`, computes the score itself, and signs a kind 30078 event. The score is never taken from the client.
- CORS allows only the origins in `ALLOWED_ORIGINS`.

What the referee can't prevent: a bot or script that actually plays the game. Runs must take at least as long as real play.

## If the referee key leaks

Generate a new key on the referee's setup page, replace `REFEREE_SECRET`, and update `REFEREE_PUBKEY` in `js/config.js`. Scores signed by the old key stop appearing on the leaderboard.

## Reporting a problem

Open a GitHub issue without exploit details and ask for a private contact, or message the maintainer on Nostr.
