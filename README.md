# Terracotta Linux — branding

Brand assets for Terracotta Linux, the distribution built on [Kiln](../kiln) — source files
(SVG, palette tokens, a sample `os-release`), not a rendered style guide.

## Name

**Terracotta** — Italian *terra cotta*, "baked earth." Unglazed, fired clay: the *product*
of firing, not the process or the vessel that holds it. Kiln fires a TOML config into an
OSTree image the same way a kiln fires raw clay into terracotta — the name pairs with the
tool instead of duplicating it: **Kiln builds it, Terracotta boots it.**

## Mark

`logo/terracotta.svg` — a **T** built from stacked, mortar-gapped brick rectangles.
Terracotta's other life is fired construction brick, not just pottery, so the mark leans on
that instead of a vessel silhouette — it reads as brick-and-mortar at a glance and stays
legible at favicon size because the gaps are structural, not decorative detail that
disappears first when a mark shrinks.

Three variants:

| File | For |
|---|---|
| `terracotta.svg` | Standard flat-color mark, transparent background. |
| `terracotta-mono.svg` | Single-color (`currentColor`) — GRUB theme, Plymouth boot splash, man pages, anywhere that can't render the full palette. |
| `terracotta-badge.svg` | Mark on a rounded terracotta square. Default choice — app icon, favicon, `.desktop` entries, and the system logo installed for freedesktop icon-theme lookups. |

## System logo

`os-release`'s `LOGO=terracotta-logo` field is a freedesktop icon-theme name, not a path —
tools like KInfoCenter's "About This System" resolve it through the icon theme rather than
reading a file directly. The package installs `terracotta-badge.svg` as that icon, at
`/usr/share/icons/hicolor/scalable/apps/terracotta-logo.svg`, so those lookups resolve to
the badge instead of falling back to a blank icon.

## Palette

See `brand/palette.md` for the full token table. Short version: primary accent is
`terracotta` (`#B5390C` light-context / `#D9673C` dark-context), background is a warm stone
(`#E7DED2`) in light and a near-black kiln-at-night tone (`#17110D`) in dark — deliberately
not the cream-and-terracotta combination every generic AI-branded page reaches for.

## `os-release`

`brand/os-release` is a filled-in sample of the file Kiln-built images ship at
`/usr/lib/os-release` — `NAME`, `ID`, `ANSI_COLOR` (the same terracotta truecolor escape as
the palette doc), `LOGO`. `HOME_URL` and friends are left unset rather than guessed; fill
those in once the project has a real one.

## Plymouth theme

`plymouth/` — a minimal `script`-module Plymouth theme named `terracotta`: the mono logo
centered on the palette's dark-context `bg` ("kiln interior at night"), with a plain
progress bar filling in dark-context `terracotta` as boot proceeds. No throbber or
frame-sequence animation, and no dependency beyond what the stock `script` splash module
already provides.

`plymouth/generate.sh` derives `logo.png` and the two progress-bar color swatches from
`logo/terracotta-mono.svg` and `brand/palette.md` — run it and commit the results after
touching either source. Requires `rsvg-convert` and ImageMagick; not part of the package
build itself.

## Wallpapers

`wallpaper/` — default desktop wallpapers at 3840×2160 and 1920×1080, generated from
`logo/terracotta.svg` centered on the palette's dark-context `bg`.

`wallpaper/generate.sh` regenerates them the same way `plymouth/generate.sh` does — run it
and commit the results after touching `logo/terracotta.svg` or `brand/palette.md`.

## Packages

`packaging/PKGBUILD` is a split package (one source tree, `pkgbase=terracotta-branding`)
producing three packages that version and release together:

| Package | Contents |
|---|---|
| `terracotta-branding` | `os-release`, logos, the icon-theme badge, the `pacman` guard script. |
| `terracotta-branding-plymouth` | The `terracotta` Plymouth theme, set as default on install. |
| `terracotta-branding-wallpapers` | The default wallpapers. |

They share one version because the Plymouth theme and wallpapers are just other renderings
of the same logo/palette source this repo already versions as a unit — there's no case here
where one needs a release the others don't. Split them into separate `PKGBUILD`s later if
that stops being true.

## What's deliberately not here

No wordmark/lockup file, no full style guide, no icon set beyond the three logo variants,
no GRUB theme — this folder is the seed set for a distro that doesn't exist as a shipped
image yet. Add to it as `terracotta-installer` and the eventual image actually need more
(a GRUB background, a `.desktop` icon set), rather than designing those blind now. ISO-boot
artifacts (GRUB/syslinux menus, the ISO volume label) belong in `terracotta-iso`, not here.
