#!/usr/bin/env bash
# Builds a single-file copy of Bomber (no Nostr) for sandboxed previews such as Claude artifacts.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; OUT="${1:-$ROOT/dist/bomber-preview.html}"; mkdir -p "$(dirname "$OUT")"
JS="$(mktemp --suffix=.js)"
bun build "$ROOT/js/main.js" --target=browser --format=iife --minify --define __BOMBER_PREVIEW__=true --outfile="$JS" >/dev/null
python3 - "$ROOT" "$JS" "$OUT" <<'PY'
import sys, re
root, js, out = sys.argv[1:4]
html = open(f'{root}/index.html').read()
body = html[html.index('<body>') + 6: html.index('</body>')]
css = open(f'{root}/css/bomber.css').read()
fonts = re.search(r'<link rel="stylesheet" href="(https://fonts[^"]+)">', html).group(1)
page = f'''<title>Bomber</title>
<meta name="claude:viewport-fit-sides" content="cover">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="{fonts}">
<style>
{css}</style>
{body}
<script>
{open(js).read()}</script>
'''
open(out, 'w').write(page)
print('wrote', out, len(page) // 1024, 'KB')
PY
