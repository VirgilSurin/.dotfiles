{ lib , stdenv , makeWrapper , bash , chromium , i3lock-color , scrot }:

stdenv.mkDerivation {
  pname = "dvd-lock";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/dvd-lock << 'EOF'
    #!${bash}/bin/bash

    # Launch chromium in app mode
    ${chromium}/bin/chromium \
      --app=https://bouncingdvdlogo.com/ \
      --start-fullscreen \
      --no-default-browser-check \
      --disable-features=TranslateUI \
      --disable-sync &

    BROWSER_PID=$!
    sleep 2

    ${scrot}/bin/scrot /tmp/screen_locked.png
    kill $BROWSER_PID

    ${i3lock-color}/bin/i3lock-color \
      -i /tmp/screen_locked.png \
      --inside-color=00000000 \
      --ring-color=ffffffff \
      --line-color=00000000 \
      --keyhl-color=00ff00ff \
      --ringver-color=00ff00ff \
      --separator-color=00000000 \
      --insidever-color=00000000 \
      --ringwrong-color=ff0000ff \
      --insidewrong-color=00000000 \
      -n
    EOF

    chmod +x $out/bin/dvd-lock
  '';

  meta = with lib; {
    description = "DVD logo screensaver lock using i3lock-color";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
