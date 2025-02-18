{ lib
, stdenv
, makeWrapper
, pipewire
, rofi
, dunst
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "rofi-sound";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 rofi-sound-output-chooser.sh $out/bin/rofi-sound
    wrapProgram $out/bin/rofi-sound \
      --prefix PATH : ${lib.makeBinPath [
        pipewire
        rofi
        dunst
      ]}
  '';

  meta = with lib; {
    description = "Script using rofi to allow sound output selection with PipeWire";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "rofi-sound";
  };
}
