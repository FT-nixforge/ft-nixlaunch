# ft-nixlaunch

A modern, polished Rofi application launcher for Wayland.
Inspired by macOS Spotlight and KDE KRunner — centered, blurred, icon-rich, and
fully configurable through Home Manager options.

> **Home Manager only.**
> ft-nixlaunch has no NixOS system-level module. Everything is configured in
> your `home.nix` (or equivalent).

---

## Features

- Centered, floating launcher with real compositor transparency
- Frosted-glass blur (Hyprland, Niri, Sway, MangoWC)
- Rounded corners — configurable radius, inner elements scale automatically
- Large app icons, clean list layout — no terminal clutter
- **Four modes**, switch with `Tab`:
  - 🚀 **Apps** — `.desktop` entries with icons
  - ⌨️  **Run** — raw shell commands
  - 📁 **Files** — fast file search via `fd`
  - 🌐 **Web** — search the web, NixOS quick-links built in
- **Single compositor setting** — one option wires in keybind + compositor rules
- **ft-nixpalette integration** — colors follow your system theme automatically
- **Stylix integration** — any base16 scheme works out of the box
- Manual color overrides when you don't use Stylix

---

## Installation

### Via ft-nixpkgs (recommended)

[ft-nixpkgs](https://github.com/FT-nixforge/ft-nixpkgs) bundles ft-nixlaunch —
no extra flake input needed.

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

  programs.ft-nixlaunch = {
    enable     = true;
    compositor = "Hyprland";
  };
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

  programs.ft-nixlaunch = {
    enable     = true;
    compositor = "Hyprland";
  };
}
```

### Package only (no module)

If you only want the binary and manage keybindings yourself:

```nix
{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.ft-nixlaunch.packages.${pkgs.system}.default ];
}
```

Add a keybinding manually in your compositor config, for example in Hyprland:

```
bind = SUPER, space, exec, ft-nixlaunch
```

---

## Quick start

The two most common setups, ready to copy:

**Hyprland + ft-nixpalette**
```nix
programs.ft-nixlaunch = {
  enable                = true;
  compositor            = "Hyprland";
  nixpaletteIntegration = true;
};
```

**Hyprland + Stylix (no ft-nixpalette)**
```nix
programs.ft-nixlaunch = {
  enable           = true;
  compositor       = "Hyprland";
  stylixIntegration = true;
};
```

**Hyprland + manual colors**
```nix
programs.ft-nixlaunch = {
  enable     = true;
  compositor = "Hyprland";
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

### `compositor`

| Type | Default |
|------|---------|
| `null` or one of the values below | `null` |

**The single setting** that wires ft-nixlaunch into your compositor or desktop
environment. Sets up a keybinding and any compositor-specific rules automatically.

| Value | Mechanism | Default keybind |
|-------|-----------|-----------------|
| `"Hyprland"` | `wayland.windowManager.hyprland.settings` | `SUPER, space` |
| `"Niri"` | `programs.niri.settings.binds` | `Mod+Space` |
| `"GNOME"` | `dconf` custom-keybindings | `<Super>space` |
| `"KDE"` | `home.activation` + `kwriteconfig6` | `Meta+Space` |
| `"COSMIC"` | COSMIC shortcuts config file (RON) | `Super` + `space` |
| `"MangoWC"` | `~/.config/mangowc/ft-nixlaunch-keybind.conf` | `SUPER, space` |
| `null` | no integration — manage keybind manually | — |

```nix
programs.ft-nixlaunch.compositor = "Hyprland";
```

Each compositor exposes optional sub-options under
`programs.ft-nixlaunch.integrations.<compositor>.*` if you need to change the
keybind or tweak compositor-specific behaviour. The defaults work out of the box
without touching any of them — see [Compositor sub-options](#compositor-sub-options)
below.

---

### Colors

#### `nixpaletteIntegration`

| Type | Default |
|------|---------|
| `bool` | `false` |

Derive launcher colors from [ft-nixpalette](https://github.com/FT-nixforge/ft-nixpalette)
via Stylix.

ft-nixpalette is a NixOS-level module. It configures Stylix system-wide, which
then exposes the active base16 palette to every Home Manager user through
`config.lib.stylix.colors`. Enabling this option reads those colors
automatically — the launcher always matches your system theme.

Requires `ft-nixpalette.enable = true` in your NixOS configuration.

```nix
# NixOS configuration
{
  imports = [ inputs.ft-nixpkgs.nixosModules.default ];
  ft-nixpalette = {
    enable = true;
    theme  = "builtin:base/catppuccin-mocha";
  };
}

# home.nix
{
  programs.ft-nixlaunch.nixpaletteIntegration = true;
}
```

#### `stylixIntegration`

| Type | Default |
|------|---------|
| `bool` | `false` |

Derive launcher colors directly from Stylix. Reads `config.lib.stylix.colors`.

If you use ft-nixpalette, prefer `nixpaletteIntegration = true` — both options
activate the same underlying Stylix color path, but the name communicates intent
more clearly.

```nix
programs.ft-nixlaunch.stylixIntegration = true;
```

#### `colors.*`

Manual hex color overrides. Only used when neither integration flag is active,
or when Stylix colors are unavailable. All values default to **Catppuccin Mocha**.

| Option | Default | Base16 slot |
|--------|---------|-------------|
| `colors.background` | `#1e1e2e` | base00 — main window background |
| `colors.backgroundAlt` | `#313244` | base01 — input bar, selected items |
| `colors.foreground` | `#cdd6f4` | base05 — primary text |
| `colors.foregroundAlt` | `#a6adc8` | base04 — placeholders, muted labels |
| `colors.accent` | `#89b4fa` | base0D — prompt, active items, mode buttons |
| `colors.urgent` | `#f38ba8` | base08 — urgent list items |

```nix
programs.ft-nixlaunch.colors = {
  background    = "#1e1e2e";
  backgroundAlt = "#313244";
  foreground    = "#cdd6f4";
  foregroundAlt = "#a6adc8";
  accent        = "#89b4fa";
  urgent        = "#f38ba8";
};
```

#### `opacity`

| Type | Default |
|------|---------|
| `str` (2-digit hex) | `"dd"` |

Hex alpha value appended to `background` and `backgroundAlt`.
Controls how transparent the launcher window appears.

| Value | Opacity |
|-------|---------|
| `"ff"` | fully opaque |
| `"dd"` | ~87 % (default) |
| `"cc"` | ~80 % |
| `"aa"` | ~67 % |
| `"00"` | fully transparent |

Text, accent, and urgent colors are always fully opaque.
Requires a compositor with real transparency support.

```nix
programs.ft-nixlaunch.opacity = "cc";
```

---

### Font

#### `font.name`

| Type | Default |
|------|---------|
| `str` | `"Inter"` |

Font family used throughout the launcher. Ensure the font is installed via
`home.packages`, `fonts.packages` (NixOS), or Stylix font defaults.

#### `font.size`

| Type | Default |
|------|---------|
| `int` | `13` |

Base font size in points. The prompt renders Bold at this size, mode-switcher
buttons at `size - 2`, and the message textbox at `size - 3`.

```nix
programs.ft-nixlaunch.font = {
  name = "JetBrainsMono Nerd Font";
  size = 13;
};
```

---

### Window

#### `window.width`

| Type | Default |
|------|---------|
| `int` | `680` |

Launcher window width in pixels. The window is always centered on screen.

#### `window.borderRadius`

| Type | Default |
|------|---------|
| `int` | `20` |

Corner radius of the launcher window in pixels. Inner elements (input bar, list
items, mode buttons) are automatically scaled down proportionally so the layered
rounded-corner hierarchy stays consistent.

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

```nix
programs.ft-nixlaunch = {
  iconSize   = 36;
  maxResults = 7;
  padding    = 24;
  spacing    = 12;
};
```

---

### Behavior

#### `searchEngine`

| Type | Default |
|------|---------|
| `str` | `"https://www.google.com/search?q="` |

URL prefix for web search queries typed in the Web mode.
The URL-encoded query is appended directly.

```nix
programs.ft-nixlaunch.searchEngine = "https://duckduckgo.com/?q=";
```

#### `browser`

| Type | Default |
|------|---------|
| `null` or `str` | `null` |

Browser command used to open search results and bookmarks.
`null` falls back to `xdg-open`.

```nix
programs.ft-nixlaunch.browser = "firefox";
```

#### `terminal`

| Type | Default |
|------|---------|
| `null` or `str` | `null` |

Terminal emulator passed to Rofi for the Run mode.
`null` uses Rofi's built-in default.

```nix
programs.ft-nixlaunch.terminal = "foot";
```

#### `extraConfig`

| Type | Default |
|------|---------|
| `lines` | `""` |

Raw rasi rules appended verbatim after the generated theme block.
Use this for overrides not exposed as module options.

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

## Compositor sub-options

These are all **optional** — defaults work without setting any of them.
Only configure the sub-options for whichever compositor you chose.

---

### Hyprland — `integrations.hyprland.*`

Activate with: `compositor = "Hyprland"`

Requires `wayland.windowManager.hyprland.enable = true` in your HM config.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `integrations.hyprland.keybind` | `str` | `"SUPER, space"` | Hyprland `bind` format: `"MODIFIER, key"` |
| `integrations.hyprland.blurLayerRules` | `bool` | `true` | Add `blur` + `ignorezero` layer rules for the Rofi surface |
| `integrations.hyprland.dimAround` | `bool` | `false` | Add `dimaround` rule — dims everything behind the launcher |

When active the module writes:
```
bind = SUPER, space, exec, ft-nixlaunch
layerrule = blur, rofi
layerrule = ignorezero, rofi
```

**Example — custom keybind, spotlight dim:**
```nix
programs.ft-nixlaunch = {
  compositor = "Hyprland";
  integrations.hyprland = {
    keybind   = "SUPER, d";
    dimAround = true;
  };
};
```

---

### Niri — `integrations.niri.*`

Activate with: `compositor = "Niri"`

Requires the Niri Home Manager module.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `integrations.niri.keybind` | `str` | `"Mod+Space"` | xkbcommon format: `"Mod+Key"` |
| `integrations.niri.cooldownMs` | `int` | `0` | Re-fire cooldown in ms; `0` = disabled |

Keybind format — modifiers: `Mod` (Super), `Ctrl`, `Alt`, `Shift`;
keys: xkbcommon names (`space`, `d`, `F2`, …).

**Example:**
```nix
programs.ft-nixlaunch = {
  compositor = "Niri";
  integrations.niri = {
    keybind    = "Mod+D";
    cooldownMs = 250;
  };
};
```

---

### GNOME — `integrations.gnome.*`

Activate with: `compositor = "GNOME"`

Registers ft-nixlaunch as a dconf custom keybinding under
`org.gnome.settings-daemon.plugins.media-keys.custom-keybindings`.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `integrations.gnome.keybind` | `str` | `"<Super>space"` | GNOME accelerator string |
| `integrations.gnome.manageBindingsList` | `bool` | `true` | Write the `custom-keybindings` dconf list entry |

Keybind format: `"<Modifier>key"` — e.g. `"<Super>space"`, `"<Control><Alt>t"`.

> **Note:** `manageBindingsList = true` **replaces** the entire `custom-keybindings`
> dconf list. If you already manage other custom GNOME shortcuts in Home Manager,
> set `manageBindingsList = false` and add the ft-nixlaunch path to your own list:
> ```nix
> dconf.settings."org/gnome/settings-daemon/plugins/media-keys" = {
>   custom-keybindings = [
>     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ft-nixlaunch/"
>     # …your other bindings…
>   ];
> };
> ```

**Example:**
```nix
programs.ft-nixlaunch = {
  compositor = "GNOME";
  integrations.gnome.keybind = "<Super>r";
};
```

---

### KDE — `integrations.kde.*`

Activate with: `compositor = "KDE"`

Writes a global shortcut entry to `~/.config/kglobalshortcutsrc` via
`kwriteconfig6` during `home-manager switch`. Handles KDE 6 (falls back to
`kwriteconfig5` for KDE 5 automatically).

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `integrations.kde.keybind` | `str` | `"Meta+Space"` | KDE notation: `"Meta+Key"` |

Keybind format — `Meta` = Super/Windows key; `Ctrl`, `Alt`, `Shift` as usual.

After switching you may need to restart the shortcut daemon:
```bash
systemctl --user restart plasma-kglobalaccel
```

**Example:**
```nix
programs.ft-nixlaunch = {
  compositor = "KDE";
  integrations.kde.keybind = "Meta+Space";
};
```

---

### COSMIC — `integrations.cosmic.*`

Activate with: `compositor = "COSMIC"`

Writes a custom shortcut in RON format to
`~/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom`.

> **Note:** COSMIC is still in alpha. If the shortcut is not picked up, verify
> the format in *System Settings → Keyboard → Shortcuts → Custom*.

> **Note:** Writing this file replaces the entire custom shortcuts list. If you
> have other COSMIC custom shortcuts, declare them via `extraShortcuts` alongside
> the ft-nixlaunch keybind.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `integrations.cosmic.modifiers` | `listOf str` | `[ "Super" ]` | Modifier keys: `"Super"`, `"Ctrl"`, `"Alt"`, `"Shift"` |
| `integrations.cosmic.key` | `str` | `"space"` | XKB keysym name (lowercase) |
| `integrations.cosmic.extraShortcuts` | list of `{ modifiers, key, command, description }` | `[]` | Other custom COSMIC shortcuts to include in the same file |

**Example — with an extra shortcut:**
```nix
programs.ft-nixlaunch = {
  compositor = "COSMIC";
  integrations.cosmic = {
    modifiers = [ "Super" ];
    key       = "space";
    extraShortcuts = [
      {
        modifiers   = [ "Super" ];
        key         = "t";
        command     = "foot";
        description = "Launch terminal";
      }
    ];
  };
};
```

---

### MangoWC — `integrations.mangowc.*`

Activate with: `compositor = "MangoWC"`

Writes a keybind snippet to `~/.config/mangowc/ft-nixlaunch-keybind.conf`.
Source it in your main `mangowc.conf`:
```
source = ~/.config/mangowc/ft-nixlaunch-keybind.conf
```

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `integrations.mangowc.keybind` | `str` | `"SUPER, space"` | MangoWC/Hyprland-style: `"MODIFIER, key"` |
| `integrations.mangowc.extraRules` | `lines` | `""` | Extra raw MangoWC rules appended to the snippet |

**Example:**
```nix
programs.ft-nixlaunch = {
  compositor = "MangoWC";
  integrations.mangowc = {
    keybind    = "SUPER, space";
    extraRules = "layerrule = blur, rofi";
  };
};
```

---

## Full example

```nix
{ inputs, ... }:
{
  imports = [ inputs.ft-nixpkgs.homeModules.default ];

  programs.ft-nixlaunch = {
    enable     = true;

    # ── Compositor ──────────────────────────────────────────────────────
    compositor = "Hyprland";
    integrations.hyprland = {
      keybind          = "SUPER, space";
      blurLayerRules   = true;
      dimAround        = false;
    };

    # ── Colors ──────────────────────────────────────────────────────────
    nixpaletteIntegration = true; # follow ft-nixpalette / Stylix theme

    # ── Font ────────────────────────────────────────────────────────────
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    # ── Window ──────────────────────────────────────────────────────────
    window = {
      width        = 680;
      borderRadius = 20;
    };
    opacity    = "dd";
    iconSize   = 36;
    maxResults = 7;
    padding    = 24;
    spacing    = 12;

    # ── Behavior ────────────────────────────────────────────────────────
    searchEngine = "https://duckduckgo.com/?q=";
    browser      = "firefox";
    terminal     = "foot";
  };
}
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

## Compositor blur setup

ft-nixlaunch uses `transparency: "real"` in its rasi theme. Your compositor must
have blur enabled for the Rofi layer-shell surface.

### Hyprland

When `compositor = "Hyprland"` and `blurLayerRules = true` (default), these are
written automatically:
```
layerrule = blur, rofi
layerrule = ignorezero, rofi
```

For a spotlight-style dim, enable `dimAround = true` or add manually:
```
layerrule = dimaround, rofi
```

### Niri

Niri applies blur globally to all windows. No extra config is needed.

### Sway / SwayFX

SwayFX supports per-surface blur:
```
blur enable
layer_effects "rofi" blur enable
```

### Other Wayland compositors

Enable blur for Rofi's layer-shell surface in your compositor's settings.

---

## Project structure

```
ft-nixlaunch/
├── flake.nix
├── pkgs/
│   └── default.nix                    package derivation
├── modules/
│   ├── home.nix                       entry point — imports all sub-modules
│   ├── options/
│   │   ├── behavior.nix               enable, searchEngine, browser, terminal, extraConfig
│   │   ├── colors.nix                 nixpaletteIntegration, stylixIntegration, colors.*, opacity
│   │   ├── compositor.nix             compositor — the single DE/compositor chooser
│   │   ├── font.nix                   font.name, font.size
│   │   └── window.nix                 window.*, iconSize, maxResults, padding, spacing
│   ├── config/
│   │   ├── base.nix                   home.packages (installs the binary)
│   │   └── theme.nix                  color resolution, rasi theme, xdg files, session vars
│   └── integrations/de/
│       ├── default.nix                imports all DE modules
│       ├── hyprland.nix               keybind + blur layer rules
│       ├── niri.nix                   keybind via programs.niri.settings.binds
│       ├── gnome.nix                  keybind via dconf custom-keybindings
│       ├── kde.nix                    keybind via home.activation + kwriteconfig6
│       ├── cosmic.nix                 keybind via COSMIC shortcuts config (RON)
│       └── mangowc.nix               keybind via mangowc config snippet
├── scripts/
│   ├── ft-nixlaunch-launcher.sh       main launcher binary
│   ├── file-search.sh                 file search mode (rofi script protocol)
│   └── web-search.sh                  web search mode (rofi script protocol)
└── themes/
    └── ft-nixlaunch.rasi              fallback theme (Catppuccin Mocha)
```

---

## Licence

MIT