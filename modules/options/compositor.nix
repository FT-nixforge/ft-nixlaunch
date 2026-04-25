# ft-nixlaunch — compositor chooser
#
# Declares the single top-level option:
#   programs.ft-nixlaunch.compositor
#
# This is the one setting a user needs to wire ft-nixlaunch into their
# desktop environment or compositor.  The chosen value activates the
# matching integration module under integrations/de/, which adds a
# keybinding and any compositor-specific rules automatically.
#
# Per-compositor tweaks (keybind string, blur rules, etc.) live under
# programs.ft-nixlaunch.integrations.<compositor>.* and are all optional
# — the defaults work out of the box for every supported compositor.
{ lib, ... }:

{
  options.programs.ft-nixlaunch.compositor = lib.mkOption {
    type = lib.types.nullOr (lib.types.enum [
      "Hyprland"
      "Niri"
      "GNOME"
      "KDE"
      "COSMIC"
      "MangoWC"
    ]);
    default = null;
    description = ''
      Compositor or desktop environment to integrate ft-nixlaunch with.

      Setting this to a non-null value automatically:
        - registers a keybinding to launch ft-nixlaunch
        - applies any compositor-specific rules (e.g. blur + ignorezero
          layer rules for Hyprland)

      Leave as `null` (the default) to manage your keybinding manually.

      Supported values:

        "Hyprland"
          Adds a bind and layer rules via
          wayland.windowManager.hyprland.settings.
          Keybind format: "MODIFIER, key"  (e.g. "SUPER, space")
          Tweak under: programs.ft-nixlaunch.integrations.hyprland.*

        "Niri"
          Adds a bind via programs.niri.settings.binds.
          Keybind format: "Mod+Key"  (e.g. "Mod+Space")
          Tweak under: programs.ft-nixlaunch.integrations.niri.*

        "GNOME"
          Registers a custom keybind via dconf custom-keybindings.
          Keybind format: GNOME accelerator string  (e.g. "<Super>space")
          Tweak under: programs.ft-nixlaunch.integrations.gnome.*

        "KDE"
          Writes a global shortcut via home.activation + kwriteconfig6.
          Keybind format: "Meta+Key"  (e.g. "Meta+Space")
          Tweak under: programs.ft-nixlaunch.integrations.kde.*

        "COSMIC"
          Writes a custom shortcut to the COSMIC shortcuts config file.
          Configured via modifiers list + key name  (e.g. ["Super"] + "space")
          Tweak under: programs.ft-nixlaunch.integrations.cosmic.*

        "MangoWC"
          Writes a keybind snippet to ~/.config/mangowc/ft-nixlaunch-keybind.conf.
          Keybind format: "MODIFIER, key"  (same as Hyprland)
          Tweak under: programs.ft-nixlaunch.integrations.mangowc.*
    '';
    example = "Hyprland";
  };
}
