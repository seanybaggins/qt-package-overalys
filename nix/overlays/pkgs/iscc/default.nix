{ stdenv
, fetchurl
, innoextract
, runtimeShell
, wineWow64Packages
, lib
}:

let
  version = "6.2.2";
  majorVersion = builtins.substring 0 1 version;
in
stdenv.mkDerivation rec {
  name = "iscc";
  inherit version;
  src = fetchurl {
    url = "https://files.jrsoftware.org/is/${majorVersion}/innosetup-${version}.exe";
    hash = "sha256-gRfRDQCirTOhOQl46jhyhhwzDgh5FEEKY3eyLExbhWM=";
  };
  nativeBuildInputs = [
    innoextract
    wineWow64Packages.stable
  ];
  unpackPhase = ''
    innoextract $src
  '';
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp -r ./app/* $out/bin

    cat << 'EOF' > $out/bin/${name}
    #!${runtimeShell}
    export PATH=${wineWow64Packages.stable}/bin:$PATH
    export WINEDLLOVERRIDES="mscoree=" # disable mono

    # Solves PermissionError: [Errno 13] Permission denied: '/homeless-shelter/.wine'
    export HOME=$(mktemp -d)

    wineInputFile=$(${wineWow64Packages.stable}/bin/wine winepath -w $1)
    ${wineWow64Packages.stable}/bin/wine $out/bin/ISCC.exe $wineInputFile
    EOF

    substituteInPlace $out/bin/${name} \
      --replace "\$out" "$out"

    chmod +x $out/bin/${name}
  '';


  meta = with lib; {
    description = "A compiler for Inno Setup, a tool for creating Windows installers.";
    homepage = "https://jrsoftware.org/isinfo.php";
    #license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
