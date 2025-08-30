{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, glibc
, gcc-unwrapped
, SDL2
, libGL
, xorg
, wayland
, libxkbcommon
, polkit
}:

stdenv.mkDerivation rec {
  pname = "memsed";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/WillyJL/MemSed/releases/${version}/download/memsed";
    sha256 = "sha256-nHaydD/fOI3tTdeNXwmU0W9U/IXd2dE69GrdLsBQmxY=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    glibc
    gcc-unwrapped.lib
    stdenv.cc.cc.lib
  ];

  runtimeDependencies = [
    SDL2
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXxf86vm
    wayland
    libxkbcommon
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    # Install the actual binary
    install -D -m755 $src $out/share/memsed/memsed-bin

    # Create a wrapper that handles display properly
    makeWrapper $out/share/memsed/memsed-bin $out/bin/memsed-wrapped \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDependencies}"

    # Create a launcher script that preserves display environment
    cat > $out/bin/memsed << 'EOF'
    #!/bin/sh
    if [ "$EUID" -ne 0 ]; then
        # Not root, use pkexec with display preservation
        pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY $out/bin/memsed-wrapped "$@"
    else
        # Already root
        exec $out/bin/memsed-wrapped "$@"
    fi
    EOF

    chmod +x $out/bin/memsed

    # Create polkit policy file
    install -D -m644 /dev/stdin $out/share/polkit-1/actions/org.memsed.policy << EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE policyconfig PUBLIC
     "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
     "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
    <policyconfig>
      <action id="org.memsed.run">
        <description>Run MemSed memory editor</description>
        <message>Authentication is required to run MemSed</message>
        <defaults>
          <allow_any>auth_admin</allow_any>
          <allow_inactive>auth_admin</allow_inactive>
          <allow_active>auth_admin</allow_active>
        </defaults>
        <annotate key="org.freedesktop.policykit.exec.path">$out/bin/memsed-wrapped</annotate>
        <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
      </action>
    </policyconfig>
    EOF

    substituteInPlace $out/bin/memsed --replace '$out' "$out"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Memory editor for Linux";
    homepage = "https://github.com/WillyJL/MemSed";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lefantom ];
    mainProgram = "memsed";
  };
}
