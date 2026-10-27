#!/bin/sh
# Builds the class copy of Space First from the main site's page.
# The copy has no link back to the rest of the site, its own stylesheet, the notice about anonymous use,
# and the address of the Google Apps Script that records it (log-url.txt; empty = records nothing).
# Usage: ./sync.sh   — then commit and push this folder.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="${SPACE_FIRST_SRC:-$HOME/Github/works/space-first.html}"
CSS="${SPACE_FIRST_CSS:-$HOME/Github/assets/site-typography.css}"
mkdir -p "$HERE/assets"
cp "$CSS" "$HERE/assets/site-typography.css"
python3 - "$SRC" "$HERE/index.html" "$HERE/log-url.txt" <<'PY'
import sys, re, os
src, out, urlfile = sys.argv[1:4]
s = open(src, encoding='utf-8').read()
url = open(urlfile).read().strip() if os.path.exists(urlfile) else ''

def must(old, new):
    global s
    if s.count(old) != 1:
        sys.exit(f'sync: expected one "{old[:60]}" in the page, found {s.count(old)} — check the page and this script')
    s = s.replace(old, new)

# no way back to the rest of the site
must('            <a href="../index.html">&larr; Index</a>\n', '')
# the stylesheet travels with the copy
s = re.sub(r'href="\.\./assets/site-typography\.css[^"]*"', 'href="assets/site-typography.css"', s)
if '../' in s.split('<script id="engine">')[0]:
    sys.exit('sync: the page still points outside its folder — check the head and the study bar')
# the recorder's address, before the page's own scripts
must('<script id="engine">', f'<script>window.SF_LOG_URL = {url!r};</script>\n<script id="engine">' if url else '<script id="engine">')
# the notice, at the end of the page
must('    <details class="notes" id="sources">',
     '    <p class="scope-note class-note">Class version: this page records anonymous use — which spaces, systems and views are explored, and for how long — to improve the course. No names or other personal details are collected.</p>\n    <details class="notes" id="sources">')
open(out, 'w', encoding='utf-8').write(s)
print(f'sync: wrote {out}' + ('' if url else ' (no log-url.txt — it records nothing yet)'))
PY
