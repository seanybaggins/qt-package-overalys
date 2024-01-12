{ qtModule
, qtbase
, qtlanguageserver
, qtshadertools
, openssl
, python3
, stdenv
, pkgsBuildBuild
, lib
, isCrossBuild ? stdenv.hostPlatform != stdenv.buildPlatform
}:

qtModule {
  pname = "qtdeclarative";
  qtInputs = [ qtbase qtlanguageserver qtshadertools ];
  propagatedBuildInputs = [ openssl ];
  nativeBuildInputs = [ python3 ];
  patches = [
    # prevent headaches from stale qmlcache data
    ../patches/qtdeclarative-default-disable-qmlcache.patch
  ];
  cmakeFlags = [ ] ++ lib.optionals isCrossBuild [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ];

}
