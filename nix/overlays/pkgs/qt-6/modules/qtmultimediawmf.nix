{ qtModule
, lib
, stdenv
, qtbase
, qtdeclarative
, qtshadertools
, qtsvg
, pkg-config
, isCrossBuild ? stdenv.hostPlatform != stdenv.buildPlatform
}:

qtModule rec {
  pname = "qtmultimediawmf";
  qtInputs = [ qtbase qtdeclarative qtsvg qtshadertools ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ];
  configurePhase = ''
    cmake --install ./src/plugins/multimedia/windows ${lib.concatStringsSep " " cmakeFlags}
  '';

  cmakeFlags = [ ] ++ lib.optionals isCrossBuild [
    #"-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
    #"-DQt6Multimedia_DIR=${pkgsBuildBuild.qt6.qtmultimedia}/lib/cmake/Qt6Multimedia"
    #"-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ] ++ lib.optionals (isCrossBuild && stdenv.hostPlatform.isMinGW) [
    #"-DQT_MEDIA_BACKEND=ffmpeg"
    #"-DFEATURE_wmf=ON"
    #"-DFEATURE_gstreamer=OFF"
  ];
}
