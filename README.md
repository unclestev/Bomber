# Bomber

Sparky is on the rooftop tossing lit bombs, and you have three water buckets to catch every one. Miss once and they all go off.

- **Classic** – a pixel-for-pixel tribute to 1981 Atari 2600 arcade play: chunky sprites, chiptune bleeps, a woodgrain TV frame.
- **Next Gen** – the same game rebuilt with high-res graphics, a city skyline, explosions, combo multipliers, gold bombs, power-ups (Wide Buckets, Slow-Mo, Shield) and a soundtrack that speeds up with every wave.
- **Verified Nostr leaderboard** – sign in with your Nostr extension or signer app, and post scores that a referee has replayed and checked.

Play with touch, keyboard, mouse, a gamepad, or a Logitech G29 racing wheel. Runs in any modern browser with no install.

**Play:** https://unclestev.github.io/bomber/

## Controls

| Input | Move | Start a drop | Pause |
|---|---|---|---|
| Touch | Drag anywhere below the screen | Tap | Pause button |
| Keyboard | ← → or A D | Space / Enter | P / Esc |
| Mouse | Move over the screen | Click | P / Esc |
| Logitech G29 | Turn the wheel | Any button | Options |

Wheel sensitivity, invert and centering are in Settings.

## Nostr: sign-in and verified scores

Bomber never asks for, sees or stores your private key. You sign in with one of:

- **A browser extension** (NIP-07): Alby or nos2x on desktop, Nostash in Safari on iPhone/iPad.
- **A signer app** (NIP-46 Nostr Connect): Amber, nsec.app or any Nostr Connect signer. Scan the code or tap to open, then approve. You can also paste a `bunker://` link.

Your signer asks you before anything is signed. Bomber only ever requests two things: a one-time login to the referee (kind 27235, never published) and, if you tap Share, a public note you have previewed (kind 1).

### How scores are verified

1. When a signed-in game starts, the referee hands out a sealed ticket with a random seed for that game.
2. The game is fully deterministic, so the seed plus your bucket position on every 1/60 s frame recreates the whole game.
3. At game over you tap **Post verified score**. The referee replays your inputs with the same rules (`js/sim.js`), computes the score itself, and signs it with the referee's Nostr key.
4. The leaderboard only shows scores signed by the referee, and checks every signature.

Typing in a fake score, editing memory, reusing a ticket or posting someone else's run all fail. No web game can stop a bot that genuinely plays well; the referee also rejects runs that finish faster than real time.

Scores are NIP-78 app-data events (kind 30078) authored by the referee, one per player per mode (`d` tag `bomber:<mode>:<pubkey>`), tagged `t: bomber-<mode>`.

See [SECURITY.md](SECURITY.md) for the full key-safety design and [referee/README.md](referee/README.md) to run the referee.

## Project layout

```
index.html          page markup and Content Security Policy
css/bomber.css      styles
js/sim.js           game rules: deterministic, shared by the browser and the referee
js/replay.js        compact replay encoding
js/main.js          rendering, sound, input, menus
js/nostr.js         sign-in, leaderboard, verified posting, sharing
js/config.js        relays and referee address
vendor/             pinned nostr-tools subset and qrcode-generator (see THIRD_PARTY_LICENSES.md)
referee/            Cloudflare Worker that verifies runs
tools/              build scripts for the vendor bundle and the single-file preview
```

No build step is needed for the site: GitHub Pages serves these files as-is. Open `index.html` through any local web server to play locally.

If you change `js/sim.js`, keep it deterministic: no `Math.random`, no clock, no `Math.sin`/`exp`, fixed 60 Hz steps. Old replays will stop verifying after rule changes, so redeploy the referee together with the site.

Inspired by Kaboom! (Activision, 1981). Not affiliated with or endorsed by Activision.
