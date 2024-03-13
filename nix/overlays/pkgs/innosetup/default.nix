{ stdenv
, wine
, fetchgit
, fetchurl
, pkgsBuildBuild
, innoextract
, unzip
}:

stdenv.mkDerivation rec {
  name = "innosetup";
  version = "6.2.2";
  #src = fetchgit {
  #  url = "https://githhub.com/jrsoftware/issrc.git";
  #  hash = "sha256-jPEupuaQkwdBgV8f/vrK09ce/3T96LtRyEVkTHopV1Q=";
  #};
  #buildPhase = ''
  #  export HOME=$(mktemp -d) # avoid access to /homeless-shelter/.
  #  wine build-ce.bat
  #'';
  src = fetchurl {
    url = "https://files.jrsoftware.org/is/6/innosetup-6.2.2.exe";
    hash = "sha256-gRfRDQCirTOhOQl46jhyhhwzDgh5FEEKY3eyLExbhWM=";
  };
  nativeBuildInputs = [ innoextract ];
  unpackPhase = ''
    innoextract $src
  '';
  buildPhase = ''
    mkdir -p $out
    cp -r ./app/* $out
  '';
  #dontUnpack = true;
  #installPhase = ''
  #  mkdir -p $out/bin
  #  cp $src $out/bin/is.exe
  #'';

}
