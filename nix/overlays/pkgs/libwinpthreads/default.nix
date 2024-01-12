{ stdenv
, fetchgit
, autoreconfHook
, lib
, windows
}:

stdenv.mkDerivation {
  pname = "libwinpthreads";
  version = "11.0.0.r198.g93ca95b32";

  src = fetchgit {
    url = "https://git.code.sf.net/p/mingw-w64/mingw-w64";
    rev = "93ca95b3274ec5674db2210f6ea631e78e4b62af";
    sha256 = "sha256-G/mCKq285PO+UBzS6njOphTs1+Ut9BUhHP/P1q0vp0w=";
  };

  nativeBuildInputs = [ autoreconfHook ]; # Includes tools like autoreconf

  buildInputs = [ windows.mingw_w64.dev ];

  patches = [ ./0001-Define-__-de-register_frame_info-in-fake-libgcc_s.patch ]; # Assuming you have this patch in your Nixpkgs directory or modify the path accordingly

  preAutoreconf = ''
    cd $src/mingw-w64-libraries/winpthreads
  '';

  autoreconfFlags = "-vfi";

  configureFlags = [
    "--includedir=$src/mingw-w64-headers/include"
    "--enable-static"
    "--enable-shared"
    # Add more flags as necessary, especially considering the MINGW-specific environment vars
  ];

  postPatch = ''
    # Logic from prepare function:
    rm -f mingw-w64-libraries/winpthreads/src/libgcc/dll_frame_info.c
  '';


  # Since build & install phases in the original PKGBUILD are more complex, you might need
  # to provide custom build & install phases or postBuild, preInstall hooks. 
  # Example:
  # buildPhase = ''
  #   # Custom build logic here...
  # '';

  # installPhase = ''
  #   # Custom install logic here...
  #   # including logic from _install_licenses and package_winpthreads-git functions
  # '';

  meta = {
    description = "MinGW-w64 winpthreads library";
    homepage = "https://mingw-w64.sourceforge.io/";
    license = with lib.licenses; [ mit bsdOriginal ]; # Matching the MIT and BSD licenses
    maintainers = [ /* Add maintainers here */ ];
    platforms = lib.platforms.windows; # Or refine the platforms as necessary
  };
}
