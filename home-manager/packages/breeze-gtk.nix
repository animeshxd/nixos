{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "breeze-gtk";
  version = "git-666b573";

  src = pkgs.fetchFromGitHub {
    owner = "animeshxd";
    repo = "breeze-gtk";
    rev = "666b5738fd3d68d8e8114b07b1214ae52a052126";
    hash = "sha256-bW0Z9+DGHJzRv1e2ReVcGlKLyyPxuWai+XlM6VN7d78";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.ninja
    pkgs.pkg-config
    pkgs.kdePackages.extra-cmake-modules
    pkgs.python3
    pkgs.python3Packages.pycairo
    pkgs.sassc
  ];

  buildInputs = [
    pkgs.gtk3
    pkgs.kdePackages.breeze
  ];
}
