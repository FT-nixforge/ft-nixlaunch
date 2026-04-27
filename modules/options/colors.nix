# ft-nixlaunch — color options
{ lib, ... }:

{
  options.programs.ft-nixlaunch = {

    # ── Theme source ────────────────────────────────────────────────────────

    theme = lib.mkOption {
      type = lib.types.enum [ "default" "stylix" "ft-nixpalette" ];
      default = "default";
      description = ''
        Color source for the launcher theme.

          "default"      — use the manual colors.* values (Catppuccin Mocha by default)
          "stylix"       — read colors from config.lib.stylix.colors (requires Stylix)
          "ft-nixpalette" — same as "stylix"; ft-nixpalette configures Stylix system-wide
      '';
      example = "stylix";
    };

    # ── Manual color palette ────────────────────────────────────────────────
    # Used when theme = "default", or as fallback when Stylix is unavailable.
    # Defaults to Catppuccin Mocha.

    colors = {
      background = lib.mkOption {
        type    = lib.types.str;
        default = "#1e1e2e";
        description = "Primary background color (base00). Main launcher window.";
        example = "#1e1e2e";
      };

      backgroundAlt = lib.mkOption {
        type    = lib.types.str;
        default = "#313244";
        description = "Secondary background color (base01). Input bar and selected items.";
        example = "#313244";
      };

      foreground = lib.mkOption {
        type    = lib.types.str;
        default = "#cdd6f4";
        description = "Primary text color (base05).";
        example = "#cdd6f4";
      };

      foregroundAlt = lib.mkOption {
        type    = lib.types.str;
        default = "#a6adc8";
        description = "Muted text color (base04). Placeholders, secondary labels.";
        example = "#a6adc8";
      };

      accent = lib.mkOption {
        type    = lib.types.str;
        default = "#89b4fa";
        description = "Accent color (base0D). Prompt, active items, mode buttons.";
        example = "#89b4fa";
      };

      urgent = lib.mkOption {
        type    = lib.types.str;
        default = "#f38ba8";
        description = "Urgent / error color (base08).";
        example = "#f38ba8";
      };
    };

    # ── Opacity ─────────────────────────────────────────────────────────────

    opacity = lib.mkOption {
      type    = lib.types.str;
      default = "dd";
      description = ''
        Two-digit hex alpha appended to background and backgroundAlt.
        "00" = fully transparent, "ff" = fully opaque, "dd" = ~87% (default).
        Requires a compositor with real transparency support.
      '';
      example = "cc";
    };
  };
}
