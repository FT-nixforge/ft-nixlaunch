# ft-nixlaunch — theme generation and runtime config
{ config, lib, ... }:

let
  cfg = config.programs.ft-nixlaunch;

  # ── Color resolution ──────────────────────────────────────────────────────
  stylixAvailable =
    (config ? stylix)
    && (config.stylix.enable or false)
    && (config ? lib)
    && (config.lib ? stylix)
    && (config.lib.stylix ? colors);

  stylixColors = if stylixAvailable then config.lib.stylix.colors else null;

  useStyleix = (cfg.theme == "stylix" || cfg.theme == "ft-nixpalette") && stylixColors != null;

  resolvedColors =
    if useStyleix then
      {
        background    = "#${stylixColors.base00}";
        backgroundAlt = "#${stylixColors.base01}";
        foreground    = "#${stylixColors.base05}";
        foregroundAlt = "#${stylixColors.base04}";
        accent        = "#${stylixColors.base0D}";
        urgent        = "#${stylixColors.base08}";
      }
    else
      {
        inherit (cfg.colors)
          background
          backgroundAlt
          foreground
          foregroundAlt
          accent
          urgent
          ;
      };

  # Convenience aliases
  c  = resolvedColors;
  a  = cfg.opacity;
  f  = cfg.font;
  w  = cfg.window;
  r  = toString w.borderRadius;
  ri = toString (w.borderRadius - 8);
  re = toString (w.borderRadius - 10);

  # ── Rasi theme ────────────────────────────────────────────────────────────
  generatedTheme = ''
    /* ft-nixlaunch — generated theme (do not edit; configure via Nix module) */

    * {
        bg:          ${c.background}${a};
        bg-alt:      ${c.backgroundAlt}${a};
        fg:          ${c.foreground};
        fg-alt:      ${c.foregroundAlt};
        accent:      ${c.accent};
        urgent:      ${c.urgent};
        transparent: #00000000;

        font: "${f.name} ${toString f.size}";

        background-color: transparent;
        text-color:       @fg;
    }

    window {
        transparency:     "real";
        location:         center;
        anchor:           center;
        fullscreen:       false;
        width:            ${toString w.width}px;
        border-radius:    ${r}px;
        background-color: @bg;
        border:           0px;
        cursor:           "default";
    }

    mainbox {
        background-color: transparent;
        children:         [ inputbar, message, listview, mode-switcher ];
        spacing:          ${toString cfg.spacing}px;
        padding:          ${toString cfg.padding}px;
    }

    inputbar {
        background-color: @bg-alt;
        border-radius:    ${ri}px;
        padding:          14px 20px;
        children:         [ prompt, textbox-prompt-colon, entry ];
        spacing:          12px;
    }

    prompt {
        background-color: transparent;
        text-color:       @accent;
        font:             "${f.name} Bold ${toString f.size}";
    }

    textbox-prompt-colon {
        expand:           false;
        str:              "";
        background-color: transparent;
        text-color:       @fg-alt;
    }

    entry {
        background-color:  transparent;
        text-color:        @fg;
        placeholder:       "Type to search...";
        placeholder-color: @fg-alt;
        cursor:            text;
    }

    listview {
        background-color: transparent;
        columns:          1;
        lines:            ${toString cfg.maxResults};
        scrollbar:        false;
        fixed-height:     true;
        spacing:          4px;
        cycle:            true;
        dynamic:          true;
        layout:           vertical;
    }

    element {
        background-color: transparent;
        padding:          10px 16px;
        border-radius:    ${re}px;
        spacing:          14px;
        cursor:           pointer;
        orientation:      horizontal;
    }

    element normal.normal,
    element alternate.normal {
        background-color: transparent;
    }

    element selected.normal {
        background-color: @bg-alt;
        text-color:       @fg;
    }

    element normal.urgent,
    element alternate.urgent {
        text-color: @urgent;
    }

    element selected.urgent {
        background-color: @urgent;
        text-color:       @bg;
    }

    element normal.active,
    element alternate.active {
        text-color: @accent;
    }

    element selected.active {
        background-color: @accent;
        text-color:       @bg;
    }

    element-icon {
        size:             ${toString cfg.iconSize}px;
        background-color: transparent;
        cursor:           inherit;
    }

    element-text {
        background-color: transparent;
        vertical-align:   0.5;
        cursor:           inherit;
    }

    message {
        background-color: transparent;
        padding:          0px 4px;
    }

    textbox {
        background-color: transparent;
        text-color:       @fg-alt;
        font:             "${f.name} ${toString (f.size - 3)}";
    }

    mode-switcher {
        background-color: transparent;
        spacing:          8px;
        padding:          0px 8px 0px 8px;
    }

    button {
        background-color: transparent;
        text-color:       @fg-alt;
        padding:          8px 16px;
        border-radius:    ${re}px;
        cursor:           pointer;
        font:             "${f.name} ${toString (f.size - 2)}";
    }

    button selected {
        background-color: @bg-alt;
        text-color:       @accent;
    }
  '';

in
{
  config = lib.mkIf cfg.enable {

    xdg.configFile."ft-nixlaunch/theme.rasi".text =
      generatedTheme + cfg.extraConfig;

    xdg.configFile."ft-nixlaunch/config".text = ''
      ft_nixlaunch_SEARCH_ENGINE="${cfg.searchEngine}"
      ft_nixlaunch_BROWSER="${if cfg.browser != null then cfg.browser else ""}"
      ft_nixlaunch_TERMINAL="${if cfg.terminal != null then cfg.terminal else ""}"
    '';

    home.sessionVariables = {
      ft_nixlaunch_THEME  = "${config.xdg.configHome}/ft-nixlaunch/theme.rasi";
      ft_nixlaunch_CONFIG = "${config.xdg.configHome}/ft-nixlaunch/config";
    };
  };
}
