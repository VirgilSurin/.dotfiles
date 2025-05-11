{ pkgs, config, lib, self, inputs, allowed-unfree-packages, ... }:

let
  inherit
  (inputs.nix-colors.lib-contrib {inherit pkgs;})
    gtkThemeFromScheme;
in
{

  imports = [
      inputs.nix-colors.homeManagerModules.default
      ../window_managers/hyprland.nix
      # ../window_managers/hyprlock.nix
      ../window_managers/qtile.nix
      ../programs/alacritty.nix
      ../programs/waybar.nix
      ../programs/wofi.nix
      ../programs/rofi.nix
      ../programs/picom.nix
      ../programs/btop.nix
      ../programs/git.nix
      ../programs/dunst.nix
      ../programs/fish.nix
      ../programs/zsh.nix
      ../programs/bash.nix
      ../programs/zoxide.nix
      ../programs/eza.nix
      ../programs/zathura.nix
      ../programs/autorandr.nix
      ../programs/xscreensaver.nix
      ../programs/sioyek.nix
      # ../programs/emacs-theme.nix
  ];


  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-soft;
  # colorScheme = inputs.nix-colors.colorSchemes.everforest;
  colorScheme = inputs.nix-colors.colorSchemes.onedark;

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
    blueman
    wirelesstools
    rofi-network-manager

  ];

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
