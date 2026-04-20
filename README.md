# nixprism

A modern, polished Rofi application launcher for NixOS and Wayland.
Inspired by macOS Spotlight and KDE KRunner — centered, blurred, and fully configurable via Nix options.

## Highlights

- Centered launcher with blurred transparency and rounded corners
- Multiple modes: **Apps**, **Run**, **Files** (fd), **Web** — switch with `Tab`
- Hyprland integration — auto-adds keybinding and blur layer rules
- Stylix integration — colors auto-derived from the active Base16 scheme
- Fully configurable: colors, fonts, sizes, keybindings via Home Manager options

## Quick Install

```nix
inputs.nixprism.url = "github:FT-nixforge/nixprism";
```

```nix
imports = [ inputs.nixprism.homeManagerModules.default ];
programs.nixprism = {
  enable              = true;
  hyprlandIntegration = true;
  stylixIntegration   = true;
};
```

## Documentation

Full documentation, options reference, and examples:  
**[ft-nixforge.github.io/community/ft-nixprism](https://ft-nixforge.github.io/community/ft-nixprism)**

## License

MIT
