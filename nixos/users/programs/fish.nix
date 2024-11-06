{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      hh="echo hello world";
      vi="nvim";
      vim="nvim";

      # python="python3.11";
      # python3="python3.11";

      cfg="sudo nvim /etc/nixos/configuration.nix";
      nrs="sudo nixos-rebuild switch";
      hms="home-manager switch";
      rebuild="sudo nixos-rebuild switch --flake ~/.dotfiles/nixos/#virgil";
      update="nix flake update";

      # Changing "ls" to "exa"
      ls="eza -al --color=always --group-directories-first --icons"; # my preferred listing
      la="eza -a --color=always --group-directories-first --icons";  # all files and dirs
      ll="eza -l --color=always --group-directories-first --icons";  # long format
      lt="eza -aT --color=always --group-directories-first --icons"; # tree listing

      # Changing cd to zoxide
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

    shellInitLast = ''zoxide init fish | source
uv generate-shell-completion fish | source
'';
  };
}
