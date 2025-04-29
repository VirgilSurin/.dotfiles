{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName  = "VirgilSurin";
    userEmail = "virgil.surin@student.umons.ac.be";
  };
}
