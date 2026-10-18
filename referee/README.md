# Bomber referee

A Cloudflare Worker that replays finished Bomber runs and signs verified scores with its own Nostr key.

## Deploy from GitHub (works from a phone)

1. In the Cloudflare dashboard, go to **Workers & Pages → Create → Import a repository**, and pick this repo.
2. Set **Root directory** to `referee`. Leave the deploy command as `npx wrangler deploy`. Deploy.
3. Open the Worker's address (`https://bomber-referee.<your-subdomain>.workers.dev`). The setup page shows a freshly generated random key.
4. In the Worker, go to **Settings → Variables and Secrets → Add**. Choose type **Secret**, name it `REFEREE_SECRET`, paste the key, and save.
5. Reload the Worker's address. It now shows two lines with the referee URL and public key. Put them in `js/config.js` and push.

The referee is then live: signed-in players get ranked runs and can post verified scores.

## Settings

- `ALLOWED_ORIGINS` (in `wrangler.toml`): sites allowed to call the referee from a browser. Defaults to `https://unclestev.github.io`.
- `REFEREE_SECRET` (secret): the referee's Nostr private key, 64 hex characters. Never commit it.

## CPU limits

Verifying a run replays every frame. Cloudflare's free plan allows 10 ms of CPU per request. Short and medium games fit; very long games (or the first request after the Worker wakes up) can exceed it, and the player sees an error. If that happens often, move the Worker to a paid plan, which allows much more CPU time per request.

## Updating the game rules

The referee bundles `../js/sim.js`. When the rules change, Cloudflare redeploys the Worker automatically on push (if you connected the repo), so the site and referee stay in step. Runs in progress during a deploy may fail to verify.
