#!/bin/sh
# Builds every note of every series in both languages.
set -eu
cd "$(dirname "$0")/.."
for d in */[0-9][0-9]-*/; do
  for l in de en; do
    [ -f "$d/$l.md" ] && tools/build.sh "$d" "$l"
  done
done
