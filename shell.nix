let
  nixpkgs = import <nixpkgs> {};
  pythonWithPackages = nixpkgs.python3.withPackages (p: with p; [
    sh
    pillow
    numpy
  ]);
in
  with nixpkgs;

  stdenv.mkDerivation {
    name = "youtube-to-cc";
    buildInputs = [
      pythonWithPackages
      ffmpeg
      yt-dlp
    ];
  }