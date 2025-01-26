{ lib , rustPlatform , pkg-config , xorg , pam , speed ? 2}:

rustPlatform.buildRustPackage {
  pname = "dvd-lockscreen";
  version = "0.1.0";

  src = ./.;

  cargoSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorg.libX11 pam ];

  meta = with lib; {
    description = "DVD bouncing logo lockscreen";
    license = licenses.mit;
    maintainers = [];
  };
}
