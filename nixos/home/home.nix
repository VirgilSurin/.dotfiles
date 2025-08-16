{ pkgs, config, lib, self, inputs, allowed-unfree-packages, ... }:

{
  nixpkgs.overlays = builtins.attrValues inputs.self.overlays;

  imports = [
      inputs.nix-colors.homeManagerModules.default

      ../modules/alacritty.nix
      ../modules/zen.nix
      ../modules/git.nix
      ../modules/zsh.nix
      ../modules/eza.nix
      ../modules/zoxide.nix
      ../modules/rofi.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.onedark;

  home.username = "virgil";
  home.homeDirectory = "/home/virgil";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    vlc
    qimgv
    chromium
    unstable.bitwarden
    unstable.signal-desktop
    unstable.protonmail-desktop
    tailscale-systray
    prismlauncher
    bottles
    memsed

    dwt1-shell-color-scripts
    neovim

    xdotool # for window killing in KDE
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

  gtk.enable = true;
  qt.enable = true;

  programs.home-manager.enable = true;
  xsession.enable = true;
}
