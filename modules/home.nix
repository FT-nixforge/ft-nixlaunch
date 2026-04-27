# ft-nixlaunch — Home Manager module entry point
self:
{ ... }:

{
  _module.args.ft-nixlaunchSelf = self;

  imports = [
    # ── Options ──────────────────────────────────────────────────────────
    ./options/behavior.nix   # enable, searchEngine, browser, terminal, extraConfig
    ./options/colors.nix     # theme, colors.*, opacity
    ./options/font.nix       # font.name, font.size
    ./options/window.nix     # window.*, iconSize, maxResults, padding, spacing

    # ── Config ───────────────────────────────────────────────────────────
    ./config/base.nix        # home.packages — installs the ft-nixlaunch package
    ./config/theme.nix       # color resolution, rasi theme, xdg files, session vars
  ];
}
