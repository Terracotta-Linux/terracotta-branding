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
| `terracotta.svg` | Standard flat-color mark. Default choice. |
| `terracotta-mono.svg` | Single-color (`currentColor`) — GRUB theme, Plymouth boot splash, man pages, anywhere that can't render the full palette. |
| `terracotta-badge.svg` | Mark on a rounded terracotta square. App icon, favicon, `.desktop` entries — anything that needs a filled background rather than transparency. |

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

## What's deliberately not here

No wordmark/lockup file, no wallpaper, no full style guide, no icon set beyond the three
logo variants — this folder is the seed set for a distro that doesn't exist as a shipped
image yet. Add to it as `terracotta-installer` and the eventual image actually need more
(a Plymouth theme, a GRUB background, a wallpaper, a `.desktop` icon set), rather than
designing those blind now.
