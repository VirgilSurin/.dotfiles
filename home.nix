{ config, lib, pkgs, ... }:

{

  home.username = "virgil";
  home.homeDirectory = "/home/virgil";

  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    texlive.combined.scheme-full
    alacritty
    btop
    emacs29-gtk3
    librewolf
    discord
    chromium                    # I need a chromium web browser sometimes
    wally-cli
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
    ranger
    powerline-go
    powerline-symbols
    powerline-fonts
    # linux utilities
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
    acpilight
    brightnessctl
    fd
    imagemagick
    ffmpegthumbnailer
    mediainfo
    poppler
    i3lock-color                # lock screen
    scrot                       # screenshots
    nerdfonts
    zip
    unzip
    xclip
    xdotool
    xorg.xprop
    xorg.xwininfo
    glxinfo
    arandr

    # Arduino
    arduino

    # wifi and bluetooth
    blueman
    networkmanagerapplet
    wirelesstools

    # programming langages
    libclang
    jdk19_headless
    nodejs_20
    emacsPackages.lsp-pyright

    (python311.withPackages(ps: with ps; [ pandas
                                           numpy
                                           # needed for Qtile
                                           pulsectl-asyncio
                                           xcffib
                                           cairocffi
                                         ]))
  ];

  programs.home-manager.enable = true;

  home.sessionPath = [
    # DO NOT FORGET TO LOG OUT AND LOG IN
   "$HOME/.config/emacs/bin"
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient -t -a ''";
    VISUAL = "emacsclient -c -a emacs";
    TERM = "xterm-256color";
  };

  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
    fadeDelta = 10;
    opacityRules = [
      "85:class_g = 'URxvt'"
      # "60:class_g = 'Alacritty'"
    ];
    settings = {
      blur = {
        method = "gaussian";
        size = 5;
        deviation = 5.0;
      };
      corner-radius = 14.0;
      round-borders = 1;
    };
  };

  xsession.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 10;
      draw_bold_text_with_bright_colors = true;
      window = {
        opacity = 0.6;
      };
      colors = {
         primary = {
           background = "#2b3339";
           foreground= "#d3c6aa";
         };
         normal = {
           black  = "#9099AB";
           red    = "#e67e80";
           green  = "#a7c080";
           yellow = "#dbbc7f";
           blue   = "#7fbbb3";
           magenta= "#d699b6";
           cyan   = "#83c092";
           white  = "#d3c6aa";
         };
         bright = {
           black  = "#9099AB";
           red    = "#e67e80";
           green  = "#a7c080";
           yellow = "#dbbc7f";
           blue   = "#7fbbb3";
           magenta= "#d699b6";
           cyan   = "#83c092";
           white  = "#d3c6aa";
         };
      };
    };
  };

  programs.fish = {
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
      ls="eza -al --color=always --group-directories-first --icons"; # my preferred listing
      la="eza -a --color=always --group-directories-first --icons";  # all files and dirs
      ll="eza -l --color=always --group-directories-first --icons";  # long format
      lt="eza -aT --color=always --group-directories-first --icons"; # tree listing

      grep="grep --color=auto";

      rr="curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash";
    };

    shellInit = ''
set fish_greeting "Hello There!"

function vterm_printf;
    if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end
        # tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end
function vterm_prompt_end;
    vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)
end
functions --copy fish_prompt vterm_old_fish_prompt
function fish_prompt --description 'Write out the prompt; do not replace this. Instead, put this at end of your file.'
    # Remove the trailing newline from the original prompt. This is done
    # using the string builtin from fish, but to make sure any escape codes
    # are correctly interpreted, use %b for printf.
    printf "%b" (string join "\n" (vterm_old_fish_prompt))
    vterm_prompt_end
end

### SET EITHER DEFAULT EMACS MODE OR VI MODE ###
function fish_user_key_bindings
  fish_default_key_bindings
end
### END OF VI MODE ###

    '';

  };

  programs.bash = {
    enable = false;
    shellAliases = {

      # man="emacsclient -c -a 'emacs' --eval '(man \'$1\')'";

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
