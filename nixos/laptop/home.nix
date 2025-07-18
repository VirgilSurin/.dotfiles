{ pkgs, config, lib, self, inputs, allowed-unfree-packages, ... }:

let
  myOne = {
    slug = "myOne";
    name = "myOne";
    author = "Virgil Surin";
    palette = {
      base00 = "#282c34";
      base01 = "#353b45";
      base02 = "#3e4451";
      base03 = "#545862";
      base04 = "#565264";
      base05 = "#abb2bf";
      base06 = "#b6bdca";
      base07 = "#c8ccd4";
      base08 = "#56b6c2";
      base09 = "#c678dd";
      base0A = "#e5c07b";
      base0B = "#98c379";
      base0C = "#d19a66";
      base0D = "#61afef";
      base0E = "#e06c75";
      base0F = "#be5046";
    };
  };
  inherit
  (inputs.nix-colors.lib-contrib {inherit pkgs;})
    gtkThemeFromScheme;
in
{
  nixpkgs.overlays = builtins.attrValues inputs.self.overlays;

  imports = [
      inputs.nix-colors.homeManagerModules.default

      ../modules/alacritty.nix
      ../modules/rofi.nix
      ../modules/rofi-powermenu.nix
      ../modules/onagre.nix # options do not exist ??
      ../modules/wofi.nix
      ../modules/dunst.nix

      # ../window_managers/qtile.nix
      # ../window_managers/hyprland.nix

      # ../modules/eww.nix
      ../modules/picom.nix
      ../modules/btop.nix
      ../modules/git.nix
      ../modules/fish.nix
      ../modules/zsh.nix
      ../modules/bash.nix
      ../modules/zoxide.nix
      ../modules/eza.nix
      ../modules/zathura.nix
      ../modules/autorandr.nix
      ../modules/sioyek.nix
  ];


  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  # colorScheme = inputs.nix-colors.colorSchemes.everforest;
  colorScheme = myOne;

  home.username = "virgil";
  home.homeDirectory = "/home/virgil";

  home.stateVersion = "23.05";


  home.packages = with pkgs; [
    texlive.combined.scheme-full
    btop
    brave
    pcmanfm
    mpv
    unstable.bitwarden
    unstable.signal-desktop
    unstable.protonmail-desktop
    dwt1-shell-color-scripts

    eww
    pamixer
    cachix

    # wallpaper
    custom-i3lock
    discord
    keymapp
    spotify
    picom
    waypaper
    qimgv # for images
    alsa-utils # for audio
    ripgrep
    fd
    dmenu
    libtool
    libvterm
    fzf
    brightnessctl
    zip
    unzip
    arandr
    flameshot
    conky

    # Audio
    pavucontrol
    pulseaudio
    mpc
    playerctl
    # wifi and bluetooth
    rofi-bluetooth
    wirelesstools
    rofi-network-manager

    networkmanagerapplet
    waybar
    wofi
    swaylock
    swaybg
    swayidle
    wl-clipboard
    nwg-displays
    nwg-panel
    vlc

  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "sioyek.desktop" "emacs.desktop" ];

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

  gtk = {
    enable = true;
    theme = {
      name = "${config.colorScheme.slug}";
      package = gtkThemeFromScheme {scheme = config.colorScheme;};
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
    style = {
      name = "Dracula";
      package = pkgs.dracula-qt5-theme;
    };
  };

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  home.sessionPath = [
   "$HOME/.config/emacs/bin"
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -t -a ''";
    VISUAL = "emacsclient -c -a emacs";
    TERM = "xterm-256color";
  };

  xsession.enable = true;

}
