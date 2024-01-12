{ lib
, stdenv
, qt6
, cmake
, zlib
}:

stdenv.mkDerivation {
  pname = "qtapp-example";
  version = "6.5.1";

  src = ./untitled;

  nativeBuildInputs = [
    #qt6.wrapQtAppsHook
    cmake
  ];

  propagatedBuildInputs = [
    qt6.qtbase
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Debug"
  ];

  postInstall = ''
    # Copy DLL files from the qtbase package
    cp -r --dereference ${qt6.qtbase}/lib/qt-6/plugins/* $out/bin
  '';

  dontWrapQtApps = true;

}
