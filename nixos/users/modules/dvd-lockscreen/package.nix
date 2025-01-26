{ lib , rustPlatform , pkg-config , xorg , pam , linux-pam, speed ? 2}:

rustPlatform.buildRustPackage {
  pname = "dvd-lockscreen";
  version = "0.1.0";

  src = ./.;

  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorg.libX11 pam linux-pam ];

  meta = with lib; {
    description = "DVD bouncing logo lockscreen";
    license = licenses.mit;
    maintainers = [];
  };
}
