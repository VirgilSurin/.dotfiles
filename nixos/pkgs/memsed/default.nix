{ lib
, stdenv
, fetchurl
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "memsed";
  version = "0.2";

  src = fetchurl {
    url = "https://github.com/WillyJL/MemSed/releases/download/v${version}/memsed";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D -m755 $src $out/bin/memsed
    runHook postInstall
  '';

  meta = with lib; {
    description = "Memory editor for Linux";
    homepage = "https://github.com/WillyJL/MemSed";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ virgil ];
  };
}
