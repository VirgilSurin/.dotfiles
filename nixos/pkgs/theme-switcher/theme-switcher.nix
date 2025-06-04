{ lib, stdenv, makeWrapper, rofi, hyprland, waybar, jq }:

stdenv.mkDerivation rec {
  pname = "theme-switcher";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ rofi hyprland waybar jq ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/theme-switcher/hyprland
    mkdir -p $out/share/theme-switcher/waybar

    # Copy theme files
    cp hyprland/*.conf $out/share/theme-switcher/hyprland/
    cp waybar/*.css $out/share/theme-switcher/waybar/

    # Install the main script
    cp theme-switcher.sh $out/bin/theme-switcher
    chmod +x $out/bin/theme-switcher

    # Wrap with dependencies
    wrapProgram $out/bin/theme-switcher \
      --prefix PATH : ${lib.makeBinPath [ rofi hyprland waybar jq ]}
  '';

  meta = with lib; {
    description = "Rofi-based theme switcher for Hyprland and Waybar";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
