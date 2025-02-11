{ lib
, stdenv
, makeWrapper
, pulseaudio
, dunst
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "rofi-sound";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kellya";
    repo = "rofi-sound";
    rev = "b32e85ecc81c3b6df1c3a88187210cbf8cabb513";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 rofi-sound $out/bin/rofi-sound
    wrapProgram $out/bin/rofi-sound \
      --prefix PATH : ${lib.makeBinPath [
        pulseaudio
        dunst
      ]}
  '';

  meta = with lib; {
    description = "Script using rofi to allow sound output selection";
    homepage = "https://github.com/kellya/rofi-sound";
    license = license.mit;
    platforms = platforms.linux;
    mainProgram = "rofi-sound";
  };
}
