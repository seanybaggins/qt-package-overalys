{ lib
, stdenv
, cmake
, ninja
, perl
, moveBuildTree
, srcs
, patches ? [ ]
, isCrossBuild ? (stdenv.hostPlatform != stdenv.buildPlatform)
, pkgsBuildBuild
, cmakeFlags ? [ ]
}:

args:

let
  inherit (args) pname;
  version = args.version or srcs.${pname}.version;
  src = args.src or srcs.${pname}.src;
in
stdenv.mkDerivation (args // {
  inherit pname version src;
  patches = args.patches or patches.${pname} or [ ];

  buildInputs = args.buildInputs or [ ];
  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ cmake ninja perl ]
    ++ lib.optionals stdenv.isDarwin [ moveBuildTree ];
  propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or [ ]);

  moveToDev = false;

  outputs = args.outputs or [ "out" "dev" ];

  dontWrapQtApps = args.dontWrapQtApps or true;

  #cmakeFlags = (args.cmakeFlags or cmakeFlags) ++ lib.optionals isCrossBuild [
  #  "-DQT_HOST_PATH=${pkgsBuildBuild.qt6.qtbase}"
  #  #"-DQt6HostInfo_DIR=${pkgsBuildBuild.qt6.qtbase}/lib/cmake/Qt6HostInfo"
  #];

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13Plus gpl2Plus lgpl21Plus lgpl3Plus ];
    maintainers = with maintainers; [ milahu nickcao ];
    platforms = platforms.all;
  } // (args.meta or { });
})
