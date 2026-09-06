#!/usr/bin/env bash
# Regenerates plymouth/logo.png, plymouth/progress-track.png and
# plymouth/progress-fill.png from logo/terracotta-mono.svg and palette.md.
# Not part of the package build (the PKGBUILD installs the committed PNGs
# directly) — run this by hand and commit the results whenever the source
# SVG or palette.md changes. Requires rsvg-convert and ImageMagick (`magick`).
set -euo pipefail

cd "$(dirname "$0")/.."

# palette.md, dark-context columns (the boot background is dark regardless
# of the installed system's light/dark theme preference):
SAND="#E8D5C0"           # `sand` — foreground on dark, used for the mono logo
TERRACOTTA="#D9673C"     # `terracotta` — accent, used for the progress fill
SURFACE_BORDER="#3A2A1E" # `surface-border` — used for the progress track

MONO_SVG="logo/terracotta-mono.svg"
OUT_DIR="plymouth"
LOGO_SIZE=220
BAR_SWATCH=4 # progress-track.png / progress-fill.png are small solid
             # swatches; the .script scales them to the on-screen bar size
             # at runtime rather than shipping a pre-sized image.

tmp_svg="$(mktemp --suffix=.svg)"
trap 'rm -f "$tmp_svg"' EXIT

# terracotta-mono.svg fills with currentColor by design (see README) so it
# can be recolored per context; rsvg-convert has no notion of CSS
# currentColor without a color to resolve it against, so substitute it here.
sed "s/currentColor/$SAND/" "$MONO_SVG" > "$tmp_svg"
rsvg-convert -w "$LOGO_SIZE" -h "$LOGO_SIZE" "$tmp_svg" -o "$OUT_DIR/logo.png"
echo "wrote $OUT_DIR/logo.png"

magick -size "${BAR_SWATCH}x${BAR_SWATCH}" "xc:$SURFACE_BORDER" "$OUT_DIR/progress-track.png"
echo "wrote $OUT_DIR/progress-track.png"

magick -size "${BAR_SWATCH}x${BAR_SWATCH}" "xc:$TERRACOTTA" "$OUT_DIR/progress-fill.png"
echo "wrote $OUT_DIR/progress-fill.png"
