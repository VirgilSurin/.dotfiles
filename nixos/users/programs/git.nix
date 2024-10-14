{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName  = "VirgilSurin";
    userEmail = "virgil.surin@student.umons.ac.be";
    extraConfig = ''
      [blame]
        ignoreRevsFile = .git-blame-ignore-revs
    '';
  };
}
