{ config, lib, pkgs, ... }:

{

  home.username = "virgil";
  home.homeDirectory = "/home/virgil";

  home.stateVersion = "23.05";
  
  home.packages = with pkgs; [
    texlive.combined.scheme-full
    alacritty
    btop
    emacs29
    librewolf
    gnome.gnome-tweaks
    gnome.gnome-software
    gnome-extension-manager
    bitwarden
    mullvad-vpn
    libreoffice
    jetbrains-mono
    emacs-all-the-icons-fonts
    tree-sitter

    # linux utilities
    ripgrep
    coreutils
    fd
    clang
    polybar
    dmenu
    gnumake
    cmake
    libtool
    libvterm
    alsa-utils
    direnv
    exa                       # the new ls !
    acpilight
    brightnessctl
    fd
    imagemagick
    ffmpegthumbnailer
    mediainfo
    poppler
    i3lock-color                # lock screen
    scrot                       # screenshots
    picom                       # window compositor
    nerdfonts
    zip
    unzip
    xclip
    xdotool
    xorg.xprop
    xorg.xwininfo
    # wifi and bluetooth
    connman
    connman-gtk
    blueman
    wirelesstools

    # programming langages
    nodejs_20
    emacsPackages.lsp-pyright

    (python311.withPackages(ps: with ps; [ pandas
                                           numpy
                                           matplotlib
                                           networkx
                                           basiciw
                                           # (
                                           #   buildPythonPackage rec {
                                           #     pname = "iwlib";
                                           #     version = "1.7.0";
                                           #     src = fetchPypi {
                                           #       inherit pname version;
                                           #       sha256 = "a805f6597a70ee3001aba8f039fb7b2dcb75dc15c4e7852f5594fd6379196da1";
                                           #     };
                                           #     doCheck = false;
                                           #     propagatedBuildInputs = [
                                           #       # Specify dependencies
                                           #       pkgs.python311Packages.cffi
                                           #     ];
                                           #   }
                                           # )
                                         ]))
  ];


  programs.home-manager.enable = true;

  home.sessionPath = [
   "$HOME/.config/emacs/bin"
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -t -a ''";
    VISUAL = "emacsclient -c -a emacs";
    TERM = "xterm-256color";
    FOO = "Hello";
  };

  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 1;
    fadeSteps = [0.01 0.05];
    shadow = false;
  };

  xsession.enable = true;

  # systemd.user.services.emacs = {
  #   Unit = {
  #     After = [ "graphical-session-pre.target" ];
  #     PartOf = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     ExecStart = "${pkgs.emacs29}/bin/emacs --daemon";
  #     ExecStop = "${pkgs.emacs29}/bin/emacsclient --eval \"(kill-emacs)\"";
  #     Restart = "always";
  #   };
  # };

  programs.bash = {
    enable = true;


    shellAliases = {
      hh="echo hello world";
      vi="nvim";
      vim="nvim";

      python="python3.11";
      python3="python3.11";

      cfg="sudo nvim /etc/nixos/configuration.nix";
      nrs="sudo nixos-rebuild switch";
      hms="home-manager switch";

      # Changing "ls" to "exa"
      ls="exa -al --color=always --group-directories-first"; # my preferred listing
      la="exa -a --color=always --group-directories-first";  # all files and dirs
      ll="exa -l --color=always --group-directories-first";  # long format
      lt="exa -aT --color=always --group-directories-first"; # tree listing

      grep="grep --color=auto";

      rr="curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash";

    };

    bashrcExtra = "
ex ()
  {
    if [ -f \"$1\" ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1   ;;
        *.tar.gz)    tar xzf $1   ;;
        *.tar)       tar xf $1    ;;
        *.tbz2)      tar xjf $1   ;;
        *.tgz)       tar xzf $1   ;;
        *.zip)       unzip $1     ;;
        *.tar.xz)    tar xf $1    ;;
        *)           echo \"'$1' cannot be extracted via ex()\" ;;
      esac
    else
      echo \"'$1' is not a valid file\"
    fi
  }

vterm_printf() {
    if [ -n \"\$TMUX\" ] && ([ \"\${TERM%%-*}\" = \"tmux\" ] || [ \"\${TERM%%-*}\" = \"screen\" ]); then
        # Tell tmux to pass the escape sequences through
        printf \"\\ePtmux;\\e\\e]%s\\007\\e\\\\\" \"\$1\"
    elif [ \"\${TERM%%-*}\" = \"screen\" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf \"\\eP\\e]%s\\007\\e\\\\\" \"\$1\"
    else
        printf \"\\e]%s\\e\\\\\" \"\$1\"
    fi
}
        ";
  };

  programs.git = {
    enable = true;
    userName  = "VirgilSurin";
    userEmail = "virgil.surin@student.umons.ac.be";
  };

}
