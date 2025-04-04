{ config, lib, pkgs, ... }:

let
  inherit (config.colorScheme) colors;
  hexToRGB = hex:
    let
      hex' = lib.removePrefix "#" hex;
      r = builtins.fromJSON ("0x" + builtins.substring 0 2 hex') / 255.0;
      g = builtins.fromJSON ("0x" + builtins.substring 2 2 hex') / 255.0;
      b = builtins.fromJSON ("0x" + builtins.substring 4 2 hex') / 255.0;
    in
      "${builtins.toString r} ${builtins.toString g} ${builtins.toString b}";

  hexToRGBA = hex: alpha:
    "${hexToRGB hex} ${builtins.toString alpha}";
in {
  programs.sioyek = {
    enable = true;
    config = {
      "dark_mode_background_color" = hexToRGB colors.base00;
      "background_color" = hexToRGB colors.base01;
      "dark_mode_contrast" = "0.9";
      "text_highlight_color" = hexToRGB colors.base0D;
      "visual_mark_color" = hexToRGBA colors.base0E "0.2";
      "ruler_mode" = "1";
      "ruler_padding" = "1.0";
      "ruler_x_padding" = "5.0";
      "visual_mark_next_page_fraction" = "0.5";
      "visual_mark_next_page_threshold" = "0.2";
      "search_highlight_color" = hexToRGB colors.base09;
      "link_highlight_color" = hexToRGB colors.base0C;
      "synctex_highlight_color" = hexToRGB colors.base0B;
      "default_dark_mode" = "1";
    };
    bindings = {
      "move_up" = "i";
      "move_down" = "e";
      "move_left" = "n";
      "move_right" = "o";
      "screen_down" = [ "d" "<c-d>" ];
      "screen_up" = [ "u" "<c-u>" ];
    };

  };

}
