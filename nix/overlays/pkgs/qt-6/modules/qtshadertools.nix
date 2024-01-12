{ qtModule
, qtbase
, stdenv
, lib
, pkgsBuildBuild
, isCrossBuild ? stdenv.hostPlatform != stdenv.buildPlatform
}:

qtModule {
  pname = "qtshadertools";
  qtInputs = [ qtbase ];
  cmakeFlags = [ ] ++ lib.optionals isCrossBuild [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
  ];
}
