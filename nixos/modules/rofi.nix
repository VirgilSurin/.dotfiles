{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;

    modes = [
      "drun"
      "run"
      "filebrowser"
    ];
    cycle = true;
    location = "center";
    plugins = [
      pkgs.rofi-calc
    ];

    extraConfig = {
      show-icons = true;
      display-drun = " ";
      display-run = "󰚺 ";
      display-filebrowser = " ";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        border-colour               = mkLiteral "#${config.colorScheme.palette.base08}";
        handle-colour               = mkLiteral "#${config.colorScheme.palette.base08}";
        background-colour           = mkLiteral "#${config.colorScheme.palette.base00}";
        foreground-colour           = mkLiteral "#${config.colorScheme.palette.base05}";
        alternate-background        = mkLiteral "#${config.colorScheme.palette.base01}";
        normal-background           = mkLiteral "#${config.colorScheme.palette.base00}";
        normal-foreground           = mkLiteral "#${config.colorScheme.palette.base05}";
        urgent-background           = mkLiteral "#${config.colorScheme.palette.base08}";
        urgent-foreground           = mkLiteral "#${config.colorScheme.palette.base00}";
        active-background           = mkLiteral "#${config.colorScheme.palette.base0D}";
        active-foreground           = mkLiteral "#${config.colorScheme.palette.base00}";
        selected-normal-background  = mkLiteral "#${config.colorScheme.palette.base08}";
        selected-normal-foreground  = mkLiteral "#${config.colorScheme.palette.base00}";
        selected-urgent-background  = mkLiteral "#${config.colorScheme.palette.base0D}";
        selected-urgent-foreground  = mkLiteral "#${config.colorScheme.palette.base00}";
        selected-active-background  = mkLiteral "#${config.colorScheme.palette.base08}";
        selected-active-foreground  = mkLiteral "#${config.colorScheme.palette.base00}";
        alternate-normal-background = mkLiteral "#${config.colorScheme.palette.base00}";
        alternate-normal-foreground = mkLiteral "#${config.colorScheme.palette.base05}";
        alternate-urgent-background = mkLiteral "#${config.colorScheme.palette.base08}";
        alternate-urgent-foreground = mkLiteral "#${config.colorScheme.palette.base00}";
        alternate-active-background = mkLiteral "#${config.colorScheme.palette.base0D}";
        alternate-active-foreground = mkLiteral "#${config.colorScheme.palette.base00}";
      };

      "window" = {
        transparency     = "real";
        location         = mkLiteral "center";
        anchor           = mkLiteral "center";
        fullscreen       = false;
        width            = mkLiteral "600px";
        x-offset         = mkLiteral "0px";
        y-offset         = mkLiteral "0px";
        enabled          = true;
        margin           = mkLiteral "0px";
        padding          = mkLiteral "0px";
        border           = mkLiteral "0px solid";
        border-radius    = mkLiteral "0px";
        border-color     = mkLiteral "@border-colour";
        cursor           = mkLiteral "default";
        background-color = mkLiteral "@background-colour";
      };

      "mainbox" = {
        enabled          = true;
        spacing          = mkLiteral "10px";
        margin           = mkLiteral "0px";
        padding          = mkLiteral "30px";
        border           = mkLiteral "2px solid";
        border-radius    = mkLiteral "0px 0px 0px 0px";
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
        children         = mkLiteral "[ \"textbox-prompt-colon\", \"entry\", \"mode-switcher\" ]";
      };

      "prompt" = {
        enabled          = true;
        background-color = mkLiteral "inherit";
        text-color       = mkLiteral "inherit";
      };

      "textbox-prompt-colon" = {
        enabled          = true;
        padding          = mkLiteral "5px 0px";
        expand           = false;
        str              = mkLiteral "\"\"";
        background-color = mkLiteral "inherit";
        text-color       = mkLiteral "inherit";
      };

      "entry" = {
        enabled          = true;
        padding          = mkLiteral "5px 0px";
        background-color = mkLiteral "inherit";
        text-color       = mkLiteral "inherit";
        cursor           = mkLiteral "text";
        placeholder      = mkLiteral "\"Search...\"";
        placeholder-color = mkLiteral "inherit";
      };

      "num-filtered-rows" = {
        enabled          = true;
        expand           = false;
        background-color = mkLiteral "inherit";
        text-color       = mkLiteral "inherit";
      };

      "textbox-num-sep" = {
        enabled          = true;
        expand           = false;
        str              = mkLiteral "\"/\"";
        background-color = mkLiteral "inherit";
        text-color       = mkLiteral "inherit";
      };

      "num-rows" = {
        enabled          = true;
        expand           = false;
        background-color = mkLiteral "inherit";
        text-color       = mkLiteral "inherit";
      };

      "case-indicator" = {
        enabled          = true;
        background-color = mkLiteral "inherit";
        text-color       = mkLiteral "inherit";
      };

      "listview" = {
        enabled          = true;
        columns          = 1;
        lines            = 8;
        cycle            = true;
        dynamic          = true;
        scrollbar        = true;
        layout           = mkLiteral "vertical";
        reverse          = false;
        fixed-height     = true;
        fixed-columns    = true;
        spacing          = mkLiteral "5px";
        margin           = mkLiteral "0px";
        padding          = mkLiteral "0px";
        border           = mkLiteral "0px solid";
        border-radius    = mkLiteral "0px";
        border-color     = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@foreground-colour";
        cursor           = mkLiteral "default";
      };

      "scrollbar" = {
        handle-width     = mkLiteral "5px";
        handle-color     = mkLiteral "@handle-colour";
        border-radius    = mkLiteral "10px";
        background-color = mkLiteral "@alternate-background";
      };

      "element" = {
        enabled          = true;
        spacing          = mkLiteral "10px";
        margin           = mkLiteral "0px";
        padding          = mkLiteral "5px 10px";
        border           = mkLiteral "0px solid";
        border-radius    = mkLiteral "10px";
        border-color     = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@foreground-colour";
        cursor           = mkLiteral "pointer";
      };

      "element normal.normal" = {
        background-color = mkLiteral "var(normal-background)";
        text-color       = mkLiteral "var(normal-foreground)";
      };

      "element normal.urgent" = {
        background-color = mkLiteral "var(urgent-background)";
        text-color       = mkLiteral "var(urgent-foreground)";
      };

      "element normal.active" = {
        background-color = mkLiteral "var(active-background)";
        text-color       = mkLiteral "var(active-foreground)";
      };

      "element selected.normal" = {
        background-color = mkLiteral "var(selected-normal-background)";
        text-color       = mkLiteral "var(selected-normal-foreground)";
      };

      "element selected.urgent" = {
        background-color = mkLiteral "var(selected-urgent-background)";
        text-color       = mkLiteral "var(selected-urgent-foreground)";
      };

      "element selected.active" = {
        background-color = mkLiteral "var(selected-active-background)";
        text-color       = mkLiteral "var(selected-active-foreground)";
      };

      "element alternate.normal" = {
        background-color = mkLiteral "var(alternate-normal-background)";
        text-color       = mkLiteral "var(alternate-normal-foreground)";
      };

      "element alternate.urgent" = {
        background-color = mkLiteral "var(alternate-urgent-background)";
        text-color       = mkLiteral "var(alternate-urgent-foreground)";
      };

      "element alternate.active" = {
        background-color = mkLiteral "var(alternate-active-background)";
        text-color       = mkLiteral "var(alternate-active-foreground)";
      };

      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "inherit";
        size             = mkLiteral "24px";
        cursor           = mkLiteral "inherit";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "inherit";
        highlight        = mkLiteral "inherit";
        cursor           = mkLiteral "inherit";
        vertical-align   = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };

      "mode-switcher" = {
        enabled          = true;
        spacing          = mkLiteral "10px";
        margin           = mkLiteral "0px";
        padding          = mkLiteral "0px";
        border           = mkLiteral "0px solid";
        border-radius    = mkLiteral "0px";
        border-color     = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@foreground-colour";
      };

      "button" = {
        padding          = mkLiteral "5px 10px";
        border           = mkLiteral "0px solid";
        border-radius    = mkLiteral "10px";
        border-color     = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        text-color       = mkLiteral "inherit";
        cursor           = mkLiteral "pointer";
      };

      "button selected" = {
        background-color = mkLiteral "var(selected-normal-background)";
        text-color       = mkLiteral "var(selected-normal-foreground)";
      };

      "message" = {
        enabled          = true;
        margin           = mkLiteral "0px";
        padding          = mkLiteral "0px";
        border           = mkLiteral "0px solid";
        border-radius    = mkLiteral "0px 0px 0px 0px";
        border-color     = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@foreground-colour";
      };

      "textbox" = {
        padding          = mkLiteral "8px 10px";
        border           = mkLiteral "0px solid";
        border-radius    = mkLiteral "10px";
        border-color     = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        text-color       = mkLiteral "@foreground-colour";
        vertical-align   = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
        highlight        = mkLiteral "none";
        placeholder-color = mkLiteral "@foreground-colour";
        blink            = true;
        markup           = true;
      };

      "error-message" = {
        padding          = mkLiteral "10px";
        border           = mkLiteral "2px solid";
        border-radius    = mkLiteral "10px";
        border-color     = mkLiteral "@border-colour";
        background-color = mkLiteral "@background-colour";
        text-color       = mkLiteral "@foreground-colour";
      };
    };
  };
}
