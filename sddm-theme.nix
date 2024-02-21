{ pkgs, ... }:

let
  imgLink = "https://github.com/VirgilSurin/.dotfiles/blob/main/wallpapers/evergreen1.jpg";
  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-csxAs16udSU0GmeD+l6kwey8bOSDc9i/cVEUBP43Su8=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "468a100460d5feaa701c2215c737b55789cba0fc";
    sha256 = "1h20b7n6a4pbqnrj22y8v5gc01zxs58lck3bipmgkpyp52ip3vig";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    rm $out/Backgrounds/background.png
    cp ${image} $out/Backgrounds/background.jpg
  '';
}
