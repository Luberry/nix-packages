{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "i3blocks-modules";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "cytopia";
    repo = "i3blocks-modules";
    rev = "0.5";
    hash = "sha256-uyhEZxd0OxEOrta0lrWmaOpLk7rj0B6FX0xPc0s93ao=";
  };
}
