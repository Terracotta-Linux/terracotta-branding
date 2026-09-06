#!/usr/bin/env bash
# Regenerates plymouth/logo.png, plymouth/spinner-track.png and the
# plymouth/spinner-NNNN.png frames from logo/terracotta-mono.svg and
# palette.md. Not part of the package build (the PKGBUILD installs the
# committed PNGs directly) — run this by hand and commit the results
# whenever the source SVG or palette.md changes. Requires rsvg-convert.
set -euo pipefail

cd "$(dirname "$0")/.."

# palette.md, dark-context columns (the boot background is dark regardless
# of the installed system's light/dark theme preference):
SAND="#E8D5C0"           # `sand` — foreground on dark, used for the mono logo
TERRACOTTA="#D9673C"     # `terracotta` — accent, used for the spinner arc
SURFACE_BORDER="#3A2A1E" # `surface-border` — used for the spinner ring

MONO_SVG="logo/terracotta-mono.svg"
OUT_DIR="plymouth"
LOGO_SIZE=220

# Spinner: a static full ring plus an arc rendered once per rotation step.
# The frames are pre-rendered here rather than produced at runtime with the
# script module's Image.Rotate because that rotation is nearest-neighbour —
# it visibly chews the arc's antialiased edge, next to a logo that is crisp.
SPINNER_SIZE=80
SPINNER_RADIUS=33
SPINNER_STROKE=5
SPINNER_ARC=0.28   # fraction of the circumference the arc covers
SPINNER_FRAMES=36  # one frame per 10° step; terracotta.script hardcodes the count

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

# terracotta-mono.svg fills with currentColor by design (see README) so it
# can be recolored per context; rsvg-convert has no notion of CSS
# currentColor without a color to resolve it against, so substitute it here.
sed "s/currentColor/$SAND/" "$MONO_SVG" > "$tmp_dir/logo.svg"
rsvg-convert -w "$LOGO_SIZE" -h "$LOGO_SIZE" "$tmp_dir/logo.svg" -o "$OUT_DIR/logo.png"
echo "wrote $OUT_DIR/logo.png"

center=$(awk "BEGIN { print $SPINNER_SIZE / 2 }")
circumference=$(awk "BEGIN { print 2 * 3.14159265358979 * $SPINNER_RADIUS }")
arc_len=$(awk "BEGIN { print $circumference * $SPINNER_ARC }")
gap_len=$(awk "BEGIN { print $circumference - $arc_len }")

# $1 = stroke color, $2 = extra circle attributes, $3 = rotation in degrees,
# $4 = output PNG. SVG circles start at 3 o'clock, so every angle is offset
# by -90° to put frame 0's arc at 12 o'clock.
render_ring() {
	cat > "$tmp_dir/ring.svg" <<-SVG
	<svg xmlns="http://www.w3.org/2000/svg" width="$SPINNER_SIZE" height="$SPINNER_SIZE" viewBox="0 0 $SPINNER_SIZE $SPINNER_SIZE">
	  <circle cx="$center" cy="$center" r="$SPINNER_RADIUS"
	          fill="none" stroke="$1" stroke-width="$SPINNER_STROKE"
	          stroke-linecap="round" $2
	          transform="rotate($(awk "BEGIN { print $3 - 90 }") $center $center)"/>
	</svg>
	SVG
	rsvg-convert -w "$SPINNER_SIZE" -h "$SPINNER_SIZE" "$tmp_dir/ring.svg" -o "$4"
}

rm -f "$OUT_DIR"/spinner-[0-9]*.png

render_ring "$SURFACE_BORDER" "" 0 "$OUT_DIR/spinner-track.png"
echo "wrote $OUT_DIR/spinner-track.png"

for ((frame = 0; frame < SPINNER_FRAMES; frame++)); do
	# Clockwise, so successive frames advance in the +ve SVG rotation direction.
	angle=$(awk "BEGIN { print $frame * 360 / $SPINNER_FRAMES }")
	out=$(printf "%s/spinner-%04d.png" "$OUT_DIR" "$frame")
	render_ring "$TERRACOTTA" "stroke-dasharray=\"$arc_len $gap_len\"" "$angle" "$out"
done
echo "wrote $OUT_DIR/spinner-0000.png .. $(printf 'spinner-%04d.png' $((SPINNER_FRAMES - 1)))"
