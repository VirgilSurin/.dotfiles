{ lib
, python3
, stdenv
, makeWrapper
, pulseaudio
, rofi
, dunst
}:

stdenv.mkDerivation {
  pname = "rofi-sound-picker";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper python3 ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp rofi-sound-picker.py $out/bin/rofi-sound-picker
    chmod +x $out/bin/rofi-sound-picker
    patchShebangs $out/bin/rofi-sound-picker
    wrapProgram $out/bin/rofi-sound-picker \
      --prefix PATH : ${lib.makeBinPath [
        pulseaudio
        rofi
        dunst
        python3
      ]} \
      --set PYTHONPATH "${python3}/lib/python${python3.pythonVersion}/site-packages" \
      --set DISPLAY ":0" \
      --prefix XDG_RUNTIME_DIR : "/run/user/1000" \
      --prefix PULSE_RUNTIME_PATH : "/run/user/1000/pulse" \
      --prefix PULSE_SERVER : "unix:/run/user/1000/pulse/native"
  '';

  meta = with lib; {
    description = "Python script using rofi to allow sound output selection with pulseaudio";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "rofi-sound-picker";
  };
}
