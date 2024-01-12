{ stdenv, fetchFromGitHub, cmake, lua, lib }:

stdenv.mkDerivation rec {
  pname = "sol2";
  version = "3.2.2";
  src = fetchFromGitHub {
    owner = "ThePhD";
    repo = "sol2";
    rev = "v${version}";
    sha256 = "sha256-KWtVEURJTU97h3vEqALb6vkyyU9SvU4P1OIuG4nBBus=";
  };
  nativeBuildInputs = [
    cmake
    lua
  ];
  buildInputs = [
  ];
  cmakeFlags = [
    "-DLUA_LOCAL_DIR=${lua}"
    "-DLUA_BUILD_TOPLEVEL=${lua}"
  ];
  installPhase = ''
    mkdir -p $out/include
    cp -r $src/include/sol $out/include/sol
    echo $out/include
  '';
  meta = with lib; {
    description = "A C++ library binding to Lua";
    homepage = "https://github.com/ThePhD/sol2";
    license = licenses.mit;
    maintainers = [ ];
  };
}
