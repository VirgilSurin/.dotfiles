{ config, lib, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;

  powerMenuScript = pkgs.writeShellScriptBin "rofi-powermenu" ''
    #!/usr/bin/env bash
uptime="`uptime | awk '{print $1}'`"
host=`hostname`
shutdown='󰐥 Shutdown'
reboot='󰜉 Reboot'
lock='󰌾 Lock'
suspend='󰒲 Suspend'
logout='󰿅 Logout'
yes='󰄬 Yes'
no=' No'
rofi_cmd() {
  rofi -dmenu \
    -p "$host" \
    -mesg "Uptime: $uptime" \
    -theme ~/.config/rofi/powermenu.rasi
}


# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
  if [[ $1 == '--shutdown' ]]; then
    systemctl poweroff
  elif [[ $1 == '--reboot' ]]; then
    systemctl reboot
  elif [[ $1 == '--suspend' ]]; then
    mpc -q pause
    amixer set Master mute
    systemctl suspend
  elif [[ $1 == '--logout' ]]; then
    if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
      openbox --exit
    elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
      bspc quit
    elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
      i3-msg exit
    elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
      qdbus org.kde.ksmserver /KSMServer logout 0 0 0
    elif [[ "$DESKTOP_SESSION" == 'qtile' ]]; then
      qtile cmd-obj -o cmd -f shutdown
    fi
  fi
}

# Actions
chosen="$(run_rofi)"
case $chosen in
    $shutdown)
    run_cmd --shutdown
        ;;
    $reboot)
    run_cmd --reboot
        ;;
    $lock)
    custom-i3lock
        ;;
    $suspend)
    run_cmd --suspend
        ;;
    $logout)
    run_cmd --logout
        ;;
esac
  '';

  powerMenuTheme = {
    "*" = {
      border-colour               = mkLiteral "#${config.colorScheme.palette.base08}";
      handle-colour               = mkLiteral "#${config.colorScheme.palette.base0E}";
      background-colour           = mkLiteral "#${config.colorScheme.palette.base00}";
      foreground-colour           = mkLiteral "#${config.colorScheme.palette.base05}";
      alternate-background        = mkLiteral "#${config.colorScheme.palette.base01}";
      normal-background           = mkLiteral "#${config.colorScheme.palette.base00}";
      normal-foreground           = mkLiteral "#${config.colorScheme.palette.base07}";
      selected-normal-background  = mkLiteral "#${config.colorScheme.palette.base08}";
      selected-normal-foreground  = mkLiteral "#${config.colorScheme.palette.base00}";
      colour1                     = mkLiteral "#${config.colorScheme.palette.base0B}";
      colour2                     = mkLiteral "#${config.colorScheme.palette.base0D}";
    };

    "window" = {
      transparency     = "real";
      location         = mkLiteral "northwest";
      anchor           = mkLiteral "northwest";
      fullscreen       = false;
      width            = mkLiteral "400px";
      x-offset         = mkLiteral "12px";
      y-offset         = mkLiteral "35px";

      enabled          = true;
      margin           = mkLiteral "0px";
      padding          = mkLiteral "0px";
      border           = mkLiteral "1px solid";
      border-radius    = mkLiteral "12px";
      border-color     = mkLiteral "@border-colour";
      cursor           = mkLiteral "default";
      background-color = mkLiteral "@background-colour";
    };

    "mainbox" = {
      enabled          = true;
      spacing          = mkLiteral "10px";
      margin           = mkLiteral "0px";
      padding          = mkLiteral "20px";
      border           = mkLiteral "0px solid";
      border-radius    = mkLiteral "12px";
      border-color     = mkLiteral "@border-colour";
      background-color = mkLiteral "transparent";
      children         = mkLiteral "[ \"inputbar\", \"message\", \"listview\" ]";
    };

    "inputbar" = {
      enabled          = true;
      spacing          = mkLiteral "10px";
      margin           = mkLiteral "0px";
      padding          = mkLiteral "0px";
      border           = mkLiteral "0px solid";
      border-radius    = mkLiteral "0px";
      border-color     = mkLiteral "@border-colour";
      background-color = mkLiteral "transparent";
      text-color       = mkLiteral "@foreground-colour";
      children         = mkLiteral "[ \"textbox-prompt-colon\", \"prompt\" ]";
    };

    "textbox-prompt-colon" = {
      enabled          = true;
      expand           = false;
      str              = "";
      padding          = mkLiteral "4px 8px";
      border-radius    = mkLiteral "10px";
      background-color = mkLiteral "transparent";
      text-color       = mkLiteral "@handle-colour";
    };

    "prompt" = {
      enabled          = true;
      padding          = mkLiteral "4px";
      border-radius    = mkLiteral "10px";
      background-color = mkLiteral "@colour1";
      text-color       = mkLiteral "@background-colour";
    };

    "message" = {
      enabled          = true;
      margin           = mkLiteral "0px";
      padding          = mkLiteral "4px";
      border           = mkLiteral "0px solid";
      border-radius    = mkLiteral "10px";
      border-color     = mkLiteral "@selected-normal-background";
      background-color = mkLiteral "@alternate-background";
      text-color       = mkLiteral "@normal-foreground";
    };

    "textbox" = {
      background-color  = mkLiteral "inherit";
      text-color        = mkLiteral "inherit";
      vertical-align    = mkLiteral "0.5";
      horizontal-align  = mkLiteral "0.0";
      placeholder-color = mkLiteral "@foreground-colour";
      blink             = true;
      markup            = true;
    };

    "error-message" = {
        padding          = mkLiteral "4px";
        border           = mkLiteral "0px solid";
        border-radius    = mkLiteral "0px";
        border-color     = mkLiteral "@selected-normal-background";
        background-color = mkLiteral "@background-colour";
        text-color       = mkLiteral "@foreground-colour";
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

      spacing          = mkLiteral "2px";
      margin           = mkLiteral "0px";
      padding          = mkLiteral "0px";
      border           = mkLiteral "0px solid";
      border-radius    = mkLiteral "0px";
      border-color     = mkLiteral "@selected-normal-background";
      background-color = mkLiteral "transparent";
      text-color       = mkLiteral "@foreground-colour";
      cursor           = mkLiteral "default";
    };

    "element" = {
      enabled          = true;
      spacing          = mkLiteral "0px";
      margin           = mkLiteral "0px";
      padding          = mkLiteral "2px";
      border           = mkLiteral "0px solid";
      border-radius    = mkLiteral "10px";
      border-color     = mkLiteral "@selected-normal-background";
      background-color = mkLiteral "transparent";
      text-color       = mkLiteral "@foreground-colour";
      cursor           = mkLiteral "pointer";
      children         = mkLiteral "[ \"element-icon\", \"element-text\" ]";
    };

    "element selected.normal" = {
      background-color = mkLiteral "@colour2";
      text-color       = mkLiteral "@selected-normal-foreground";
    };

    "element-icon" = {
      background-color = mkLiteral "transparent";
      text-color       = mkLiteral "inherit";
      cursor           = mkLiteral "inherit";
      vertical-align   = mkLiteral "0.5";
      horizontal-align = mkLiteral "0.0";
    };

    "element-text" = {
      background-color = mkLiteral "transparent";
      text-color       = mkLiteral "inherit";
      cursor           = mkLiteral "inherit";
      vertical-align   = mkLiteral "0.5";
      horizontal-align = mkLiteral "0.0";
    };
  };

  formatRasiTheme = theme:
    let
      formatRasiValue = value:
        if lib.isAttrs value && value ? _type && value._type == "literal" then
          value.value
        else if lib.isString value then
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
