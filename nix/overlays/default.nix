final: prev:

# The directory structure and overlays where derived from the following video
# https://youtu.be/yT4qkEXfagc
rec {
  libjpeg_turbo = final.callPackage ./pkgs/libjpeg-turbo { };
  libjpeg = libjpeg_turbo;
  #dav1d = final.callPackage ./pkgs/dav1d { };
  soxr = final.callPackage ./pkgs/soxr { };
  speexdsp = final.callPackage ./pkgs/speexdsp { };
  speex = final.callPackage ./pkgs/speex { };
  libtheora = final.callPackage ./pkgs/libtheora { };
  #x264 = final.callPackage ./pkgs/x264 { };
  x265 = final.callPackage ./pkgs/x265 { };
  xvidcore = final.callPackage ./pkgs/xvidcore { };
  SDL2 = final.callPackage ./pkgs/SDL2 {
    inherit (prev.darwin.apple_sdk.frameworks) AudioUnit Cocoa CoreAudio CoreServices ForceFeedback OpenGL;
  };
  libwinpthreads = final.callPackage ./pkgs/libwinpthreads { };
  #srt = final.callPackage ./pkgs/srt { };
  #freetype = final.callPackage ./pkgs/freetype { };
  #lzip = final.callPackage ./pkgs/lzip { };
  libopus = final.callPackage ./pkgs/libopus { };
  ffmpeg = final.callPackage ./pkgs/ffmpeg/5.nix {
    inherit (prev.darwin.apple_sdk.frameworks)
      Cocoa CoreServices CoreAudio CoreMedia AVFoundation MediaToolbox
      VideoDecodeAcceleration VideoToolbox;
  };
  ffmpeg_small = final.callPackage ./pkgs/ffmpeg/5.nix {
    ffmpegVariant = "small";
    inherit (prev.darwin.apple_sdk.frameworks)
      Cocoa CoreServices CoreAudio CoreMedia AVFoundation MediaToolbox
      VideoDecodeAcceleration VideoToolbox;
    withVdpau = false;
  };
  #unbound = final.callPackage ./pkgs/unbound { };
  #p11-kit = final.callPackage ./pkgs/p11-kit { };
  gnutls = final.callPackage ./pkgs/gnutls {
    inherit (prev.darwin.apple_sdk.frameworks) Security;
    util-linux = prev.util-linuxMinimal; # break the cyclic dependency
    autoconf = prev.buildPackages.autoconf269;
  };
  libtool = final.callPackage ./pkgs/libtool/libtool2.nix { };
  readline = final.callPackage ./pkgs/readline/8.2.nix { };
  sqlcipher = final.callPackage ./pkgs/sqlcipher { };
  xmlsec = final.callPackage ./pkgs/xmlsec { };
  vulkan-loader = final.callPackage ./pkgs/vulkan-loader {
    inherit (prev.darwin) moltenvk;
  };
  vulkan-headers = final.callPackage ./pkgs/vulkan-headers { };
  qt6 = final.callPackage ./pkgs/qt-6 { };
  qtapp-example = final.callPackage ./pkgs/qtapp-example { };
  lua = (final.callPackage ./pkgs/lua-5 { }).lua5_2_compat;
  sol2 = final.callPackage ./pkgs/sol2 { };
  boost171 = final.callPackage ./pkgs/boost { };
}
