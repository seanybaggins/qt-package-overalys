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
, wayland
, elfutils
, VideoToolbox
, pkgsBuildBuild
, isCrossBuild ? stdenv.hostPlatform != stdenv.buildPlatform
, withWMF ? stdenv.hostPlatform.isMinGW
}:

qtModule {
  pname = "qtmultimedia";
  qtInputs = [ qtbase qtdeclarative qtsvg qtshadertools ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isLinux [ libpulseaudio elfutils alsa-lib wayland ];

  propagatedBuildInputs =
    lib.optionals stdenv.isLinux [ gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi ]
    ++ lib.optionals stdenv.isDarwin [ VideoToolbox ]
    ++ lib.optionals withWMF [ ffmpeg ];

  patches = lib.optionals withWMF [
    ../patches/qtmultimedia-windows-no-uppercase-libs.patch
  ];

  cmakeFlags = [ ] ++ lib.optionals isCrossBuild [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
    "-DFEATURE_wmf=ON"
    "-DFEATURE_gstreamer=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin
    "-include AudioToolbox/AudioToolbox.h";
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin
    "-framework AudioToolbox";

}
