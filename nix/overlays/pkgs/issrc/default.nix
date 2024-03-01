{ stdenv
, wine
, fetchgit
, pkgsBuildBuild
}:

stdenv.mkDerivation {
  name = "issrc";
  version = "0.0.1";
  src = fetchgit {
    url = "https://github.com/jrsoftware/issrc.git";
    hash = "sha256-39msOpoa9vDqblE/ygR2wDF5HzJo7BAjpw6AtZ4YbXc=";
  };

  buildPhase = "${pkgsBuildBuild.wine} build.bat";

}
