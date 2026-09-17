#!/bin/sh
# Builds one Field Note in one language: body (pandoc + Chromium) + cover
# (template + JSON + Chromium), merged with pypdf.
#
#   tools/build.sh <note-dir> <de|en>
#
# Needs: pandoc, Google Chrome (macOS path below) or chromium in PATH,
# pdfinfo (poppler), python3. pypdf is installed into tools/.venv on first run.
set -eu
DIR=${1:?note dir}; LANG_=${2:?de|en}
TOOLS=$(cd "$(dirname "$0")" && pwd)
NOTE=$(cd "$DIR" && pwd)
SLUG=$(basename "$NOTE" | sed 's/^[0-9]*-//')
OUT="$NOTE/$SLUG-$LANG_.pdf"
WORK="$NOTE/build"; mkdir -p "$WORK"

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
[ -x "$CHROME" ] || CHROME=$(command -v chromium || command -v chromium-browser || command -v google-chrome)
VENV="$TOOLS/.venv"
[ -x "$VENV/bin/python" ] || { python3 -m venv "$VENV" && "$VENV/bin/pip" -q install pypdf; }

TITLE=$(sed -n 's/^title: *"\(.*\)"/\1/p' "$NOTE/$LANG_.md" | head -1)

# 1. body
pandoc "$NOTE/$LANG_.md" -s --toc --toc-depth=2 --syntax-highlighting=tango \
  -c "$TOOLS/style-$LANG_.css" --metadata pagetitle="$TITLE" -o "$WORK/body-$LANG_.html"
cp "$TOOLS/style-$LANG_.css" "$WORK/"
"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$WORK/body-$LANG_.pdf" "file://$WORK/body-$LANG_.html" >/dev/null 2>&1
PAGES=$(( $(pdfinfo "$WORK/body-$LANG_.pdf" | awk '/^Pages/{print $2}') + 2 ))

# 2. cover
"$VENV/bin/python" - "$TOOLS/cover-template.html" "$NOTE/cover-$LANG_.json" "$WORK/cover-$LANG_.html" "$PAGES" "file://$TOOLS/fonts.css" <<'PY'
import json, sys, re
tpl, data, out, pages, fonts = sys.argv[1:]
t = open(tpl).read(); d = json.load(open(data))
t = re.sub(r'\{\{(\w+)\}\}', lambda m: d.get(m.group(1), fonts if m.group(1)=="fonts_css" else ""), t)
open(out, "w").write(t.replace("__PAGES__", pages))
PY
"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$WORK/cover-$LANG_.pdf" "file://$WORK/cover-$LANG_.html" >/dev/null 2>&1

# 3. merge
"$VENV/bin/python" - "$WORK/cover-$LANG_.pdf" "$WORK/body-$LANG_.pdf" "$OUT" "$TITLE" <<'PY'
import sys
from pypdf import PdfReader, PdfWriter
cover, body, out, title = sys.argv[1:]
c = PdfReader(cover); b = PdfReader(body); w = PdfWriter()
w.add_page(c.pages[0])
for p in b.pages: w.add_page(p)
w.add_page(c.pages[1])
w.add_metadata({"/Title": title, "/Author": "Thomas Zachmann"})
w.write(out); print(f"{out}: {len(PdfReader(out).pages)} pages")
PY
