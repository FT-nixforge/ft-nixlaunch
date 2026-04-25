# ft-nixlaunch — DE integration importer
#
# This file only imports each per-DE module.
# The compositor selector itself lives in:
#   options/compositor.nix  →  programs.ft-nixlaunch.compositor
#
# Each DE module declares its own sub-options under
#   programs.ft-nixlaunch.integrations.<de>.*
# and gates its config on:
#   cfg.enable && cfg.compositor == "<DE>"
{ ... }:

{
  imports = [
    ./hyprland.nix
    ./niri.nix
    ./gnome.nix
    ./kde.nix
    ./cosmic.nix
    ./mangowc.nix
  ];
}
