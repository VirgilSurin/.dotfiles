{ pkgs }:

let
  imgLink = "https://github.com/VirgilSurin/.dotfiles/blob/main/wallpapers/evergreen1.jpg";
  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-QRHG5gr78AA1FPTkw62oMeyjVZbMXTvFmeEmlq/hSU4=";
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
    cd $out
    rm Backgrounds/background.png
    cp -r ${image} $out/Backgrounds/background.jpg
  '';
}
