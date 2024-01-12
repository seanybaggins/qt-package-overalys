{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libX11
, libxcb
, libXrandr
, wayland
, moltenvk
, vulkan-headers
, addOpenGLRunpath
, python3
}:

stdenv.mkDerivation rec {
  pname = "vulkan-loader";
  version = "1.3.249";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Loader";
    rev = "v${version}";
    hash = "sha256-v4GEZEcQP3+oiT66sgysIZ2PdLSidyYjecb3TmcHG2Y=";
  };

  patches = [ ./fix-pkgconfig.patch ./disable-masm.patch ];

  nativeBuildInputs = [ cmake pkg-config ]
    ++ lib.optionals stdenv.hostPlatform.isWindows [ python3 ];
  buildInputs = [ vulkan-headers ]
    ++ lib.optionals (!stdenv.isDarwin && !stdenv.hostPlatform.isWindows) [ libX11 libxcb libXrandr wayland ];

  cmakeFlags = [ "-DCMAKE_INSTALL_INCLUDEDIR=${vulkan-headers}/include" ]
    ++ lib.optional stdenv.isDarwin "-DSYSCONFDIR=${moltenvk}/share"
    ++ lib.optional stdenv.isLinux "-DSYSCONFDIR=${addOpenGLRunpath.driverLink}/share"
    ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "-DUSE_GAS=OFF"
    ++ lib.optionals stdenv.hostPlatform.isWindows [
    "-DUSE_MASM=OFF"
    "-DENABLE_WERROR=OFF"
  ];

  outputs = [ "out" "dev" ];

  doInstallCheck = true;

  installCheckPhase = ''
    grep -q "${vulkan-headers}/include" $dev/lib/pkgconfig/vulkan.pc || {
      echo vulkan-headers include directory not found in pkg-config file
      exit 1
    }
  '';

  meta = with lib; {
    description = "LunarG Vulkan loader";
    homepage = "https://www.lunarg.com";
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.asl20;
    maintainers = [ maintainers.ralith ];
    broken = (version != vulkan-headers.version);
  };
}
