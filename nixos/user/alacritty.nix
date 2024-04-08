{

  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 11;
      colors.draw_bold_text_with_bright_colors = true;
      window = {
        opacity = 1;
      };
      colors = {
         primary = {
           background = "#000000";
           foreground= "#AAAAAA";
         };
         # normal = {
         #   black  = "#${config.colorSchemes.colors.base00}";
         #   red    = "#${config.colorSchemes.colors.base0E}";
         #   green  = "#${config.colorSchemes.colors.base0D}";
         #   yellow = "#${config.colorSchemes.colors.base0A}";
         #   blue   = "#${config.colorSchemes.colors.base08}";
         #   magenta= "#${config.colorSchemes.colors.base09}";
         #   cyan   = "#${config.colorSchemes.colors.base0B}";
         #   white  = "#${config.colorSchemes.colors.base06}";
         # };
         # bright = {
         #   black  = "#${config.colorSchemes.colors.base00}";
         #   red    = "#${config.colorSchemes.colors.base0E}";
         #   green  = "#${config.colorSchemes.colors.base0D}";
         #   yellow = "#${config.colorSchemes.colors.base0A}";
         #   blue   = "#${config.colorSchemes.colors.base08}";
         #   magenta= "#${config.colorSchemes.colors.base09}";
         #   cyan   = "#${config.colorSchemes.colors.base0B}";
         #   white  = "#${config.colorSchemes.colors.base06}";
         # };
      };
    };
  };
}
