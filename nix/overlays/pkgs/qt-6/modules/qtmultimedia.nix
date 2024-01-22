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
, windows
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
    ++ lib.optionals withWMF [ windows.mingw_w64 ];
  propagatedBuildInputs =
    lib.optionals stdenv.isLinux [ gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi ]
    ++ lib.optionals stdenv.isDarwin [ VideoToolbox ];

  patches = lib.optionals withWMF [
    ../patches/qtmultimedia-windows-no-uppercase-libs.patch
  ];

  cmakeFlags = [ ] ++ lib.optionals isCrossBuild [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
    #"-DCMAKE_FIND_LIBRARY_SUFFIXES=.a"
    #"-DCMAKE_C_IMPLICIT_LINK_DIRECTORIES=${windows.mingw_w64}"
    #"-DCMAKE_INCLUDE_PATH=$src/src/multimedia/windows"
    #"-DQt6Multimedia_DIR=${pkgsBuildBuild.qt6.qtmultimedia}/lib/cmake/Qt6Multimedia"
    #"-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
  ] ++ lib.optionals withWMF [
    "-DFEATURE_wmf=ON"
    "-DQT_MEDIA_BACKEND=ffmpeg"
    #"-DFEATURE_gstreamer=OFF"
  ];

  #CMAKE_C_IMPLICIT_LINK_DIRECTORIES = lib.optionalString withWMF "${windows.mingw_w64}/lib";



  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin
    "-include AudioToolbox/AudioToolbox.h";
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin
    "-framework AudioToolbox";
}
