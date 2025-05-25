{ lib, stdenv, makeWrapper, rofi, jq, coreutils, bash }:

stdenv.mkDerivation rec {
  pname = "unified-theme-switcher";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ rofi jq coreutils bash ];

  installPhase = ''
    mkdir -p $out/bin

    # Install the main script
    cp theme-switcher.sh $out/bin/unified-theme-switcher
    chmod +x $out/bin/unified-theme-switcher

    # Wrap with dependencies
    wrapProgram $out/bin/unified-theme-switcher \
      --prefix PATH : ${lib.makeBinPath [ rofi jq coreutils bash ]}
  '';

  meta = with lib; {
    description = "Unified theme switcher for all applications";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
