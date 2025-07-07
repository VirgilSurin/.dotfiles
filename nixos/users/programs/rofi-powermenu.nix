{ config, lib, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;

  # Power menu script
  powerMenuScript = pkgs.writeShellScriptBin "rofi-powermenu" ''
    #!/usr/bin/env bash

    # Power Menu Options
    shutdown="󰐥"
    reboot=""
    lock=""
    suspend="󰤄"
    logout="󰿅"

    # Create options string
    options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

    # Show menu and get choice
    chosen="$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/powermenu.rasi -p "⏻ Power Menu")"

    case $chosen in
        $shutdown)
            systemctl poweroff
            ;;
        $reboot)
            systemctl reboot
            ;;
        $lock)
            custom-i3lock
            ;;
        $suspend)
            systemctl suspend
            ;;
        $logout)
              loginctl terminate-user $USER
            ;;
    esac
  '';

  powerMenuTheme = {
    "*" = {
      border-colour               = mkLiteral "#${config.colorScheme.palette.base08}";
      handle-colour               = mkLiteral "#${config.colorScheme.palette.base08}";
      background-colour           = mkLiteral "#${config.colorScheme.palette.base00}";
      foreground-colour           = mkLiteral "#${config.colorScheme.palette.base05}";
      alternate-background        = mkLiteral "#${config.colorScheme.palette.base01}";
      normal-background           = mkLiteral "#${config.colorScheme.palette.base00}";
      normal-foreground           = mkLiteral "#${config.colorScheme.palette.base05}";
      selected-normal-background  = mkLiteral "#${config.colorScheme.palette.base08}";
      selected-normal-foreground  = mkLiteral "#${config.colorScheme.palette.base00}";
    };

    "window" = {
      transparency     = "real";
      location         = mkLiteral "center";
      anchor           = mkLiteral "center";
      fullscreen       = false;
      width            = mkLiteral "400px";
      x-offset         = mkLiteral "0px";
      y-offset         = mkLiteral "0px";
      enabled          = true;
      margin           = mkLiteral "0px";
      padding          = mkLiteral "0px";
      border           = mkLiteral "2px solid";
      border-radius    = mkLiteral "12px";
      border-color     = mkLiteral "@border-colour";
      cursor           = mkLiteral "default";
      background-color = mkLiteral "@background-colour";
    };

    "mainbox" = {
      enabled          = true;
      spacing          = mkLiteral "15px";
      margin           = mkLiteral "0px";
      padding          = mkLiteral "30px";
      border           = mkLiteral "0px solid";
      border-radius    = mkLiteral "0px";
      border-color     = mkLiteral "@border-colour";
      background-color = mkLiteral "transparent";
      children         = mkLiteral "[ \"inputbar\", \"listview\" ]";
    };

    "inputbar" = {
      enabled          = true;
      spacing          = mkLiteral "10px";
      margin           = mkLiteral "0px 0px 20px 0px";
      padding          = mkLiteral "15px";
      border           = mkLiteral "0px solid";
      border-radius    = mkLiteral "8px";
      border-color     = mkLiteral "@border-colour";
      background-color = mkLiteral "@alternate-background";
      text-color       = mkLiteral "@foreground-colour";
      children         = mkLiteral "[ \"prompt\" ]";
    };

    "prompt" = {
      enabled          = true;
      background-color = mkLiteral "inherit";
      text-color       = mkLiteral "inherit";
    };

    "listview" = {
      enabled          = true;
      columns          = 1;
      lines            = 5;
      cycle            = true;
      dynamic          = true;
      scrollbar        = false;
      layout           = mkLiteral "vertical";
      reverse          = false;
      fixed-height     = true;
      fixed-columns    = true;
      spacing          = mkLiteral "10px";
      margin           = mkLiteral "0px";
      padding          = mkLiteral "0px";
      border           = mkLiteral "0px solid";
      border-radius    = mkLiteral "0px";
      border-color     = mkLiteral "@border-colour";
      background-color = mkLiteral "transparent";
      text-color       = mkLiteral "@foreground-colour";
      cursor           = mkLiteral "default";
    };

    "element" = {
      enabled          = true;
      spacing          = mkLiteral "15px";
      margin           = mkLiteral "0px";
      padding          = mkLiteral "15px";
      border           = mkLiteral "0px solid";
      border-radius    = mkLiteral "8px";
      border-color     = mkLiteral "@border-colour";
      background-color = mkLiteral "transparent";
      text-color       = mkLiteral "@foreground-colour";
      cursor           = mkLiteral "pointer";
    };

    "element normal.normal" = {
      background-color = mkLiteral "var(normal-background)";
      text-color       = mkLiteral "var(normal-foreground)";
    };

    "element selected.normal" = {
      background-color = mkLiteral "var(selected-normal-background)";
      text-color       = mkLiteral "var(selected-normal-foreground)";
      border-radius    = mkLiteral "8px";
    };

    "element-text" = {
      background-color = mkLiteral "transparent";
      text-color       = mkLiteral "inherit";
      highlight        = mkLiteral "inherit";
      cursor           = mkLiteral "inherit";
      vertical-align   = mkLiteral "0.5";
      horizontal-align = mkLiteral "0.5";
    };
  };

  formatRasiTheme = theme:
    let
      formatRasiValue = value:
        if lib.isString value then
          if lib.hasPrefix "mkLiteral " value then
            lib.removePrefix "mkLiteral " value
          else
            ''"${value}"''
        else if lib.isBool value then
          if value then "true" else "false"
        else if lib.isInt value then
          toString value
        else
          toString value;

      formatRasiAttrs = attrs:
        lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value:
          "  ${name}: ${formatRasiValue value};"
        ) attrs);

      formatRasiSection = name: attrs:
        "${name} {\n${formatRasiAttrs attrs}\n}";

    in lib.concatStringsSep "\n\n" (lib.mapAttrsToList formatRasiSection theme);

in
{
  home.packages = [ powerMenuScript ];
  xdg.configFile."rofi/powermenu.rasi".text = formatRasiTheme powerMenuTheme;
}
