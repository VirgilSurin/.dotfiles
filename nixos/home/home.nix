{ pkgs, config, lib, self, inputs, allowed-unfree-packages, ... }:

{
  nixpkgs.overlays = builtins.attrValues inputs.self.overlays;

  imports = [
      inputs.nix-colors.homeManagerModules.default

      ../modules/alacritty.nix
      ../modules/git.nix
      ../modules/zsh.nix
      ../modules/eza.nix
      ../modules/zoxide.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.onedark;

  home.username = "virgil";
  home.homeDirectory = "/home/virgil";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    vlc
    qimgv
    unstable.bitwarden
    unstable.signal-desktop
    unstable.protonmail-desktop

    dwt1-shell-color-scripts
    neovim
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "emacs.desktop" ];
      "image/png" = [ "qimgv.desktop" "emacs.desktop" ];
      "image/jpeg" = [ "qimgv.desktop" "emacs.desktop" ];
      "image/gif" = [ "qimgv.desktop" "emacs.desktop" ];
      "video/mp4" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "video/mkv" = [ "vlc.desktop" ];
      "x-sheme-handler/mailto" = [ "proton-mail.desktop" ];
      "text/plain" = [ "emacs.desktop" ];
    };
  };

  programs.home-manager.enable = true;
  xsession.enable = true;
}
