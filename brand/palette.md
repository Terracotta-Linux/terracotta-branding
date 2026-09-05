# Terracotta palette

Named tokens, not raw hex — reference these by name in code and design tools so a future
retune only edits this file.

| Token | Light-context hex | Dark-context hex | Use |
|---|---|---|---|
| `terracotta` | `#B5390C` | `#D9673C` | primary mark color, links, accent |
| `terracotta-glow` | `#D97142` | `#E88354` | gradients, hover/active states |
| `clay-deep` | `#6B2A0E` | `#7A2A0E` | shadows, mark depth, mono-on-dark |
| `sand` | `#F4EAD9` | `#E8D5C0` | foreground on the badge mark, text-on-dark |
| `ink` | `#241A13` | `#EDE1D3` | body text |
| `ink-muted` | `#7A6754` | `#A98F7C` | secondary text, captions |
| `bg` | `#E7DED2` | `#17110D` | page/app background |
| `surface` | `#F4EEE5` | `#241A13` | cards, panels |
| `surface-border` | `#D8C9B6` | `#3A2A1E` | hairlines, card borders |

Two hex columns, not a single accent + opacity: light-context terracotta (`#B5390C`) is
tuned to hold contrast on a pale ground, dark-context terracotta (`#D9673C`) is lifted so it
doesn't muddy against near-black. Don't reuse one column on the other background.

The light background is a warm stone (`#E7DED2`), not a cream — deliberately off the
`#F4F1EA`-and-serif look every "AI-generated" brand converges on. The dark background
(`#17110D`) is meant to read as a kiln interior at night: warm near-black, not pure `#000`.

## ANSI / terminal

Truecolor escape for `terracotta` (`#B5390C`), for anything that prints a colored prompt or
banner:

```
\033[38;2;181;57;12m
```

## Where this shows up

- `logo/` — the mark, in flat color, monochrome, and badge form.
- `os-release` — `ANSI_COLOR` below is this same truecolor escape, unquoted per spec.
