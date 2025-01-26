# default.nix
{ lib
, stdenv
, fetchFromGitHub
, python3
, xrandr
, i3lock
, pkgs
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ pygame ]);
in
stdenv.mkDerivation rec {
  pname = "dvd-lock-screen";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jmsiefer";
    repo = "DVD_Screensaver";
    rev = "70d3b5f28393e1068b7fde8096bdbe6ad422de70";
    sha256 = "sha256-yT/TqOLq/rEqI6d41XMOrlZc9XU+7qIgECydaxyuDok=";
  };

  nativeBuildInputs = [ pythonEnv ];
  buildInputs = [ xrandr i3lock ];

  installPhase = ''
    mkdir -p $out/bin $out/share/dvd-lock-screen
    install -Dm755 DVD.py $out/bin/DVD.py
    cat > $out/bin/dvd-lock-screen << EOF
    #!/bin/sh
    cd $out/share/dvd-lock-screen
    cp ${./dvd-video.png} $out/bin/DVD.png
    cp ${./sonar.mp3} $out/bin/Fart.mp3
    for monitor in \$(xrandr | grep " connected" | cut -d' ' -f1); do
      ${pythonEnv}/bin/python $out/bin/DVD.py --monitor "\$monitor" &
    done
    ${i3lock}/bin/i3lock -n -c 000000
    EOF
    chmod +x $out/bin/dvd-lock-screen
  '';

  meta = with lib; {
    description = "DVD Screensaver Lock Screen for X11";
    homepage = "https://github.com/jmsiefer/DVD_Screensaver";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
