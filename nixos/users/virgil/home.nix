{ pkgs, config, lib, self, inputs, allowed-unfree-packages, ... }:

let
  theme-switcher = pkgs.callPackage ./users/pkgs/theme-switcher/theme-switcher.nix {};
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

  imports = [
      inputs.nix-colors.homeManagerModules.default

      ../programs/alacritty.nix
      ../programs/rofi.nix
      ../programs/wofi.nix
      ../programs/dunst.nix

      ../window_managers/qtile.nix

      ../programs/picom.nix
      ../programs/btop.nix
      ../programs/git.nix
      ../programs/fish.nix
      ../programs/zsh.nix
      ../programs/bash.nix
      ../programs/zoxide.nix
      ../programs/eza.nix
      ../programs/zathura.nix
      ../programs/autorandr.nix
      ../programs/xscreensaver.nix
      ../programs/sioyek.nix
  ];


  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  # colorScheme = inputs.nix-colors.colorSchemes.everforest;
  # colorScheme = myOne;

  home.username = "virgil";
  home.homeDirectory = "/home/virgil";

  home.stateVersion = "23.05";


  home.packages = with pkgs; [
    base16-schemes
    texlive.combined.scheme-full
    alacritty
    btop
    brave
    bitwarden
    mullvad-vpn
    emacs-all-the-icons-fonts
    tree-sitter
    signal-desktop
    vlc
    pcmanfm
    mpv
    protonmail-desktop
    dwt1-shell-color-scripts

    # linux utilities

    # wallpaper
    feh
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
    fd
    imagemagick
    scrot
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-sans
    nerd-fonts.ubuntu-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    zip
    unzip
    xclip
    xdotool
    xorg.xprop
    xorg.xwininfo
    arandr
    flameshot
    conky

    nix-prefetch
    nix-prefetch-github
    nil
    nodejs_23
    pyright
    emacsPackages.lsp-pyright

    # Audio
    pavucontrol
    pulseaudio
    # wifi and bluetooth
    rofi-bluetooth
    wirelesstools
    rofi-network-manager

    # Hyprland
    networkmanagerapplet
    hyprpaper
    waybar
    wofi
    swaylock
    swaybg
    swayidle
    wl-clipboard
    nwg-displays
    nwg-panel

  ];

  xdg.configFile = {
    "theme-switcher/hyprland/one.conf".source = ./pkgs/theme-switcher/hyprland/one.conf;
    "theme-switcher/hyprland/gruvbox.conf".source = ./pkgs/theme-switcher/hyprland/gruvbox.conf;
    "theme-switcher/waybar/one.css".source = ./pkgs/theme-switcher/waybar/one.css;
    "theme-switcher/waybar/gruvbox.css".source = ./pkgs/theme-switcher/waybar/gruvbox.css;
  };

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = [ "sioyek.desktop" "emacs.desktop" ];

    "image/png" = [ "qimgv.desktop" ];
    "image/jpeg" = [ "qimgv.desktop" ];
    "image/gif" = [ "qimgv.desktop" ];

    "vidio/mp4" = [ "vlc.desktop" ];
    "vidio/webm" = [ "vlc.desktop" ];
    "vidio/mkv" = [ "vlc.desktop" ];

    "x-sheme-handler/mailto" = [ "proton-mail.desktop" ];

    "text/plain" = [ "emacs.desktop" ];

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
