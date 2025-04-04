{ config, lib, pkgs, ... }:

let
  inherit (config.colorScheme) palette;
  hexToRGB = hex:
    let
      hex' = lib.removePrefix "#" hex;
      r = lib.fromHexString ("0x" + builtins.substring 0 2 hex') / 255.0;
      g = lib.fromHexString ("0x" + builtins.substring 2 2 hex') / 255.0;
      b = lib.fromHexString ("0x" + builtins.substring 4 2 hex') / 255.0;
    in
      "${builtins.toString r} ${builtins.toString g} ${builtins.toString b}";

  hexToRGBA = hex: alpha:
    "${hexToRGB hex} ${builtins.toString alpha}";
in {
  programs.sioyek = {
    enable = true;
    config = {
      "dark_mode_background_color" = hexToRGB palette.base00;
      "background_color" = hexToRGB palette.base00;
      "custom_background_color" = hexToRGB palette.base00;

      "status_bar_color" = hexToRGB palette.base00;
      "status_bar_text_color" = hexToRGB palette.base05;

      "custom_text_color" = hexToRGB palette.base05;
      "text_highlight_color" = hexToRGB palette.base0D;
      "visual_mark_color" = hexToRGBA palette.base0E "0.2";

      "ruler_mode" = "1";
      "ruler_padding" = "1.0";
      "ruler_x_padding" = "5.0";
      "visual_mark_next_page_fraction" = "0.5";
      "visual_mark_next_page_threshold" = "0.2";
      "search_highlight_color" = hexToRGB palette.base09;
      "link_highlight_color" = hexToRGB palette.base0C;
      "synctex_highlight_color" = hexToRGB palette.base0B;

      "font_size" = "14";
      "ui_font" = "Ubuntu Nerd Font";

      "default_dark_mode" = "1";
      "startup_commands" = "toggle_custom_color;toggle_visual_scroll";
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
