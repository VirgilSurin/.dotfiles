{ lib, pkgs, ... }:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        theme = {
          enable = true;
          name = "onedark";
          style = "dark";
        };

        statusline.lualine.enable = true;
        telescope.enasble = true;
        autocomplete.nvim-cmp.enable = true;

        languages = {
          enableLSP = true;
          enableTreesitter = true;

          nix.enable = true;
          ts.enable = true;
          rust.enable = true;
          python.enable = true;

        };
      };
    };
  };

}
