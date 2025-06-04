{ lib
, stdenv
, makeWrapper
, i3lock-color
}:

stdenv.mkDerivation {
  pname = "custom-i3lock";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 lock.sh $out/bin/custom-i3lock
    wrapProgram $out/bin/custom-i3lock \
      --prefix PATH : ${lib.makeBinPath [ i3lock-color ]}
  '';

  meta = with lib; {
    description = "Custom i3lock-color script with predefined theme";
    platforms = platforms.unix;
    mainProgram = "custom-i3lock";
  };
}
