{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;

    cycle = true;
    location = "center";
    plugins = [
      pkgs.rofi-calc
    ];

    extraConfig = {

    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background-color            = mkLiteral "#${config.colorScheme.palette.base00}";
        border-color                = mkLiteral "#${config.colorScheme.palette.base08}";
        text-color                  = mkLiteral "#${config.colorScheme.palette.base05}";
        font                        = "FiraCodeNerdFontMono-Medium 12";
        prompt-font                 = "FiraCodeNerdFontMono-Medium 12";
        prompt-background           = mkLiteral "#${config.colorScheme.palette.base08}";
        prompt-foreground           = mkLiteral "#${config.colorScheme.palette.base00}";
        prompt-padding              = mkLiteral "4px";
        alternate-normal-background = mkLiteral "#${config.colorScheme.palette.base01}";
        alternate-normal-foreground = mkLiteral "@text-color";
        selected-normal-background  = mkLiteral "#${config.colorScheme.palette.base0D}";
        selected-normal-foreground  = mkLiteral "#${config.colorScheme.palette.base00}";
        spacing                     = 0;
        margin                      = 0;
        padding                     = 0;
      };
      "#window" = {
        width = mkLiteral "30%";
        border = 2;
        padding = 5;
      };
      "mainbox" = {
        border = 0;
        padding = 0;
      };
      "message" = {
        border = mkLiteral "1px dash 0px 0px";
        padding = mkLiteral "1px";
      };
      "#listview" = {
        fixed-height = 0;
        border       = mkLiteral "2px solid 0px 0px";
        border-color = mkLiteral "#${config.colorScheme.palette.base01}";
        spacing      = mkLiteral "2px";
        scrollbar    = mkLiteral "true";
        padding      = mkLiteral "2px 0px 0px";
      };
      "#element" = {
        border = 0;
        padding = mkLiteral "1px";
      };
      "#element.selected.normal" = {
        background-color = mkLiteral "@selected-normal-background";
        text-color       = mkLiteral "@selected-normal-foreground";
      };
      "#element.alternate.normal" = {
        background-color = mkLiteral "@alternate-normal-background";
        text-color       = mkLiteral "@alternate-normal-foreground";
      };
      "#scrollbar" = {
        width        = mkLiteral "0px";
        border       = 0;
        handle-width = mkLiteral "0px";
        padding      = 0;
      };
      "#sidebar" = {
        border = mkLiteral "2px dash 0px 0px";
      };
      "#button.selected" = {
        background-color = mkLiteral "@selected-normal-background";
        text-color       = mkLiteral "@selected-normal-foreground";
      };
      "#inputbar" = {
        spacing = 0;
        padding = mkLiteral "1px";
      };
      "#case-indicator" = {
        spacing = 0;
      };
      "#entry" = {
        padding = mkLiteral "4px 4px";
        expand  = mkLiteral "false";
        width   = mkLiteral "10em";
      };
      "#prompt" = {
        padding          = mkLiteral "@prompt-padding";
        background-color = mkLiteral "@prompt-background";
        text-color       = mkLiteral "@prompt-foreground";
        font             = mkLiteral "@prompt-font";
        border-radius    = mkLiteral "2px";
      };

      "element-text" = {
        background-color = mkLiteral "inherit";
        text-color       = mkLiteral "inherit";
      };
    };
  };
}
