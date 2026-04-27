# ft-nixlaunch

A modern, polished Rofi wrapper for Wayland.
Centered, blurred, icon-rich — configurable through Home Manager options.
Keybinding and compositor setup is left to the user.

> **Home Manager only.**
> ft-nixlaunch has no NixOS system-level module.

---

## Features

- Centered, floating launcher with real compositor transparency
- Rounded corners — configurable radius, inner elements scale automatically
- Large app icons, clean list layout
- **Four modes**, switch with `Tab`:
  - 🚀 **Apps** — `.desktop` entries with icons
  - ⌨️  **Run** — raw shell commands
  - 📁 **Files** — fast file search via `fd`
  - 🌐 **Web** — search the web
- **Three color sources**: Catppuccin Mocha default, Stylix, or ft-nixpalette

---

## Installation

### Via ft-nixpkgs (recommended)

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    ft-nixpkgs.url   = "github:FT-nixforge/ft-nixpkgs";
  };
}
```

```nix
# home.nix
{ inputs, ... }:
{
  imports = [ inputs.ft-nixpkgs.homeModules.default ];

  programs.ft-nixlaunch.enable = true;
}
```

### Standalone flake input

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    ft-nixlaunch.url = "github:FT-nixforge/ft-nixlaunch";
  };
}
```

```nix
# home.nix
{ inputs, ... }:
{
  imports = [ inputs.ft-nixlaunch.homeModules.default ];

  programs.ft-nixlaunch.enable = true;
}
```

### Package only (no module)

```nix
{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.ft-nixlaunch.packages.${pkgs.system}.default ];
}
```

---

## Keybinding

ft-nixlaunch does not register any keybind for you. Wire it up yourself in your
compositor config. Examples:

**Hyprland**
```
bind = SUPER, space, exec, ft-nixlaunch
```

**Niri**
```kdl
Mod+Space { spawn "ft-nixlaunch"; }
```

**Sway**
```
bindsym $mod+space exec ft-nixlaunch
```

---

## Quick start

**Default theme (Catppuccin Mocha)**
```nix
programs.ft-nixlaunch = {
  enable = true;
};
```

**With Stylix colors**
```nix
programs.ft-nixlaunch = {
  enable = true;
  theme  = "stylix";
};
```

**With ft-nixpalette**
```nix
programs.ft-nixlaunch = {
  enable = true;
  theme  = "ft-nixpalette";
};
```

**Manual colors**
```nix
programs.ft-nixlaunch = {
  enable = true;
  colors = {
    background    = "#1e1e2e";
    backgroundAlt = "#313244";
    foreground    = "#cdd6f4";
    foregroundAlt = "#a6adc8";
    accent        = "#89b4fa";
    urgent        = "#f38ba8";
  };
};
```

---

## Options reference

All options live under `programs.ft-nixlaunch`.

---

### `enable`

| Type | Default |
|------|---------|
| `bool` | `false` |

Enable ft-nixlaunch and write its configuration.

---

### `theme`

| Type | Default |
|------|---------|
| `"default"` \| `"stylix"` \| `"ft-nixpalette"` | `"default"` |

Color source for the launcher.

| Value | Behavior |
|-------|----------|
| `"default"` | Use the `colors.*` values (Catppuccin Mocha by default) |
| `"stylix"` | Read `config.lib.stylix.colors` — requires Stylix |
| `"ft-nixpalette"` | Same as `"stylix"` — ft-nixpalette configures Stylix system-wide |

```nix
programs.ft-nixlaunch.theme = "stylix";
```

---

### `colors.*`

Manual hex color overrides. Only used when `theme = "default"`, or as fallback
when Stylix colors are unavailable.

| Option | Default | Base16 slot |
|--------|---------|-------------|
| `colors.background` | `#1e1e2e` | base00 — main window background |
| `colors.backgroundAlt` | `#313244` | base01 — input bar, selected items |
| `colors.foreground` | `#cdd6f4` | base05 — primary text |
| `colors.foregroundAlt` | `#a6adc8` | base04 — placeholders, muted labels |
| `colors.accent` | `#89b4fa` | base0D — prompt, active items, mode buttons |
| `colors.urgent` | `#f38ba8` | base08 — urgent list items |

---

### `opacity`

| Type | Default |
|------|---------|
| `str` (2-digit hex) | `"dd"` |

Hex alpha appended to `background` and `backgroundAlt`.

| Value | Opacity |
|-------|---------|
| `"ff"` | fully opaque |
| `"dd"` | ~87% (default) |
| `"cc"` | ~80% |
| `"00"` | fully transparent |

Requires a compositor with real transparency support.

```nix
programs.ft-nixlaunch.opacity = "cc";
```

---

### Font

| Option | Type | Default |
|--------|------|---------|
| `font.name` | `str` | `"Inter"` |
| `font.size` | `int` | `13` |

```nix
programs.ft-nixlaunch.font = {
  name = "JetBrainsMono Nerd Font";
  size = 13;
};
```

---

### Window

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `window.width` | `int` | `680` | Width in pixels |
| `window.borderRadius` | `int` | `20` | Corner radius in pixels |

```nix
programs.ft-nixlaunch.window = {
  width        = 680;
  borderRadius = 20;
};
```

---

### Layout

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `iconSize` | `int` | `36` | App icon size in pixels |
| `maxResults` | `int` | `7` | Maximum visible result rows |
| `padding` | `int` | `24` | Inner window padding in pixels |
| `spacing` | `int` | `12` | Gap between sections in pixels |

---

### Behavior

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `searchEngine` | `str` | `"https://www.google.com/search?q="` | URL prefix for web search |
| `browser` | `null` or `str` | `null` | Browser command; `null` uses `xdg-open` |
| `terminal` | `null` or `str` | `null` | Terminal for Run mode; `null` uses Rofi default |

---

### `extraConfig`

| Type | Default |
|------|---------|
| `lines` | `""` |

Raw rasi rules appended after the generated theme block.

```nix
programs.ft-nixlaunch.extraConfig = ''
  window {
    width: 800px;
    border: 2px;
    border-color: @accent;
  }
'';
```

---

## Usage

### Command line

```bash
ft-nixlaunch           # App launcher (default)
ft-nixlaunch run       # Command runner
ft-nixlaunch files     # File search
ft-nixlaunch web       # Web search
ft-nixlaunch --help    # Show all options
```

### Keyboard shortcuts inside the launcher

| Key | Action |
|-----|--------|
| `Tab` | Next mode |
| `Shift+Tab` | Previous mode |
| `Alt+A` | Jump to Apps mode |
| `Alt+R` | Jump to Run mode |
| `Alt+F` | Jump to Files mode |
| `Alt+W` | Jump to Web mode |
| `Enter` | Open / execute selection |
| `Escape` | Close launcher |
| `↑` / `↓` | Navigate results |

---

## Blur setup

ft-nixlaunch uses `transparency: "real"` in its rasi theme. Enable blur for
Rofi's layer-shell surface in your compositor.

**Hyprland**
```
layerrule = blur, rofi
layerrule = ignorezero, rofi
# optional spotlight dim:
layerrule = dimaround, rofi
```

**Niri** — applies blur globally, no extra config needed.

**SwayFX**
```
blur enable
layer_effects "rofi" blur enable
```

---

## Full example

```nix
{ inputs, ... }:
{
  imports = [ inputs.ft-nixpkgs.homeModules.default ];

  programs.ft-nixlaunch = {
    enable = true;
    theme  = "ft-nixpalette";

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    window = {
      width        = 680;
      borderRadius = 20;
    };
    opacity    = "dd";
    iconSize   = 36;
    maxResults = 7;
    padding    = 24;
    spacing    = 12;

    searchEngine = "https://duckduckgo.com/?q=";
    browser      = "firefox";
    terminal     = "foot";
  };
}
```

---

## Project structure

```
ft-nixlaunch/
├── flake.nix
├── pkgs/
│   └── default.nix                    package derivation
├── modules/
│   ├── home.nix                       entry point
│   ├── options/
│   │   ├── behavior.nix               enable, searchEngine, browser, terminal, extraConfig
│   │   ├── colors.nix                 theme, colors.*, opacity
│   │   ├── font.nix                   font.name, font.size
│   │   └── window.nix                 window.*, iconSize, maxResults, padding, spacing
│   └── config/
│       ├── base.nix                   home.packages
│       └── theme.nix                  color resolution, rasi theme, xdg files, session vars
├── scripts/
│   ├── ft-nixlaunch-launcher.sh       main launcher binary
│   ├── file-search.sh                 file search mode
│   └── web-search.sh                  web search mode
└── themes/
    └── ft-nixlaunch.rasi              fallback theme (Catppuccin Mocha)
```

---

## Licence

MIT
