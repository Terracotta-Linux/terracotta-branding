#!/usr/bin/env bash
# Regenerates wallpaper/*.png from logo/terracotta.svg. Not part of the
# package build (the PKGBUILD installs the committed PNGs directly) — run
# this by hand and commit the results whenever the source SVG or palette.md
# changes. Requires rsvg-convert and ImageMagick (`magick`).
set -euo pipefail

cd "$(dirname "$0")/.."

# palette.md `bg`, dark-context: "kiln interior at night" near-black.
BG="#17110D"
LOGO_SVG="logo/terracotta.svg"
OUT_DIR="wallpaper"

# resolution -> rendered logo height in px (kept small relative to the
# canvas; this is a wallpaper accent, not a poster).
declare -A RESOLUTIONS=(
	[3840x2160]=520
	[1920x1080]=260
)

tmp_logo="$(mktemp --suffix=.png)"
trap 'rm -f "$tmp_logo"' EXIT

for res in "${!RESOLUTIONS[@]}"; do
	logo_size="${RESOLUTIONS[$res]}"
	rsvg-convert -w "$logo_size" -h "$logo_size" "$LOGO_SVG" -o "$tmp_logo"

	out="$OUT_DIR/terracotta-default-$res.png"
	magick -size "$res" "xc:$BG" \
		"$tmp_logo" -gravity center -compose over -composite \
		"$out"

	echo "wrote $out"
done
