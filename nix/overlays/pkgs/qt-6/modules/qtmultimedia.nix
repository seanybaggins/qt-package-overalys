{ qtModule
, lib
, stdenv
, qtbase
, qtdeclarative
, qtshadertools
, qtsvg
, pkg-config
, alsa-lib
, ffmpeg
, gstreamer
, gst-plugins-base
, gst-plugins-good
, gst-libav
, gst-vaapi
, libpulseaudio
, libwmf
, wayland
, elfutils
, orc
, VideoToolbox
, pkgsBuildBuild
, qtmultimediawmf
, isCrossBuild ? stdenv.hostPlatform != stdenv.buildPlatform
, withWMF ? stdenv.hostPlatform.isMinGW
}:

qtModule {
  pname = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative qtsvg qtshadertools ];
  #++ lib.optionals isCrossBuild [ qtmultimediawmf ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ffmpeg ]
    ++ lib.optionals stdenv.isLinux [ libpulseaudio elfutils alsa-lib wayland ]
    ++ lib.optionals withWMF [ ];
  propagatedBuildInputs =
    lib.optionals stdenv.isLinux [ gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi ]
    ++ lib.optionals stdenv.isDarwin [ VideoToolbox ];
  cmakeFlags = [ ] ++ lib.optionals isCrossBuild [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
    #"-DCMAKE_INCLUDE_PATH=$src/src/multimedia/windows"
    #"-DQt6Multimedia_DIR=${pkgsBuildBuild.qt6.qtmultimedia}/lib/cmake/Qt6Multimedia"
    #"-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ] ++ lib.optionals withWMF [
    "-DFEATURE_wmf=OFF"
    "-DQT_MEDIA_BACKEND=ffmpeg"
    #"-DFEATURE_gstreamer=OFF"
  ];

  #preConfigure = ''
  #  cmake --install ./src/plugins/multimedia/windows
  #'';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin
    "-include AudioToolbox/AudioToolbox.h";
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin
    "-framework AudioToolbox";
}
