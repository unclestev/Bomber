// Bomber settings you may want to change.

// Where the game lives (used in shared notes).
export const APP_URL = 'https://unclestev.github.io/bomber/';

// Relays used to read and publish scores and profiles.
export const RELAYS = ['wss://relay.damus.io', 'wss://nos.lol', 'wss://relay.primal.net'];

// Relays used only to talk to a signer app over Nostr Connect (NIP-46).
export const CONNECT_RELAYS = ['wss://relay.nsec.app', 'wss://relay.damus.io'];

// The referee checks replays and signs verified scores.
// Fill these in after deploying referee/ (its home page shows both values).
export const REFEREE_URL = '';     // e.g. 'https://bomber-referee.yourname.workers.dev'
export const REFEREE_PUBKEY = '';  // 64-character hex public key of the referee

// Verified scores are NIP-78 app-data events (kind 30078) authored by the referee.
export const SCORE_KIND = 30078;
