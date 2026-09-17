#!/bin/sh
# Renders only the cover (front + back) of a note as <slug>-<lang>-preview.pdf.
# For planned notes that have cover copy but no text yet.
#   tools/build-cover.sh <note-dir> <de|en>
set -eu
DIR=${1:?note dir}; LANG_=${2:?de|en}
TOOLS=$(cd "$(dirname "$0")" && pwd); NOTE=$(cd "$DIR" && pwd)
SLUG=$(basename "$NOTE" | sed 's/^[0-9]*-//'); WORK="$NOTE/build"; mkdir -p "$WORK"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
[ -x "$CHROME" ] || CHROME=$(command -v chromium || command -v chromium-browser || command -v google-chrome)
python3 - "$TOOLS/cover-template.html" "$NOTE/cover-$LANG_.json" "$WORK/cover-$LANG_.html" <<'PY'
import json, sys, re
tpl, data, out = sys.argv[1:]
t = open(tpl).read(); d = json.load(open(data))
t = re.sub(r'\{\{(\w+)\}\}', lambda m: d[m.group(1)], t)
open(out, "w").write(t.replace("__PAGES__", "–"))
PY
"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer --virtual-time-budget=8000 \
  --print-to-pdf="$NOTE/$SLUG-$LANG_-preview.pdf" "file://$WORK/cover-$LANG_.html" >/dev/null 2>&1
echo "$NOTE/$SLUG-$LANG_-preview.pdf"
