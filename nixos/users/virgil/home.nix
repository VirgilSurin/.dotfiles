{ pkgs, config, lib, self, inputs, ... }:

{

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../window_managers/hyprland.nix
    # ../window_managers/hyprlock.nix
    ../programs/alacritty.nix
    ../programs/waybar.nix
    ../programs/wofi.nix
    ../programs/picom.nix
    ../programs/fish.nix
    ../programs/bash.nix
    ../programs/zathura.nix
    ../programs/emacs-theme.nix
    # ../window_managers/qtile.nix
    # ../modules/qtile.nix
  ];


  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-soft;
  colorScheme = inputs.nix-colors.colorSchemes.everforest;
  # colorScheme = inputs.nix-colors.colorSchemes.onedark;

  home.username = "virgil";
  home.homeDirectory = "/home/virgil";

  home.stateVersion = "23.05";


  home.packages = with pkgs; [
    (import ../shell_scripts/make-shell.nix {inherit pkgs; })
    base16-schemes
    texlive.combined.scheme-full
    alacritty
    btop
    firefox
    rofi
    chromium                    # I need a chromium web browser sometimes
    firefox
    bitwarden
    mullvad-vpn
    libreoffice
    jetbrains-mono
    emacs-all-the-icons-fonts
    neofetch
    tree-sitter
    texlab
    signal-desktop
    vlc
    pcmanfm
    zathura
    evince

    # wayland related things
    wofi
    waybar
    swww

    # unfree
    # discord

    # Mail
    mu
    isync
    # linux utilities
    shutter
    gtk3
    webkitgtk
    libusb1
    ripgrep
    coreutils
    fd
    clang
    dmenu
    gnumake
    cmake
    libtool
    libvterm
    alsa-utils
    direnv
    nix-direnv
    eza                       # the new ls !
    zoxide                    # the better cd !
    fzf
    acpilight
    brightnessctl
    fd
    imagemagick
    ffmpegthumbnailer
    mediainfo
    poppler
    i3lock-color                # lock screen
    pinentry-rofi
    # for screenshot
    grim
    slurp
    wl-clipboard

    nerdfonts
    zip
    unzip
    xclip
    xdotool
    xorg.xprop
    xorg.xwininfo
    glxinfo
    arandr
    flameshot

    nix-prefetch
    nix-prefetch-github
    nil # nix lsp

    # Arduino
    # arduino

    # wifi and bluetooth
    blueman
    wirelesstools

    # programming langages
    python3
    libclang
    jdk
    nodejs_20
    rustc
    cargo
    rust-analyzer

    # (python311.withPackages(ps: with ps; [ pandas
    #                                        numpy
    #                                        # needed for Qtile
    #                                        qtile
    #                                        qtile-extras
    #                                        pulsectl-asyncio
    #                                        xcffib
    #                                        cairocffi
    #                                      ]))
  ];

  programs.home-manager.enable = true;

  home.sessionPath = [
    # DO NOT FORGET TO SOURCE bashrc/config.fish
   "$HOME/.config/emacs/bin"
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -t -a ''";
    VISUAL = "emacsclient -c -a emacs";
    TERM = "xterm-256color";
  };

  xsession.enable = true;

  programs.git = {
    enable = true;
    userName  = "VirgilSurin";
    userEmail = "virgil.surin@student.umons.ac.be";
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-rofi;
  };

  programs.gpg = {
    enable = true;
  };

  services.mbsync = {
    enable = true;
  };

}
