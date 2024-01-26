{ lib
, stdenv
, qt6
, cmake
, buildPackages
, ffmpeg
, gnutls
, srt
, libffi
}:

let
  installerScriptBuilderOutput = "Z:\\home\\youruser\\desired\\path";
in
stdenv.mkDerivation
rec {
  pname = "qtapp-example";
  version = "6.5.1";

  src = ./untitled;

  nativeBuildInputs = [
    cmake
    buildPackages.findutils
  ];

  propagatedBuildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  postInstall = ''
    # Copy DLL for application
    cp -r ${qt6.qtbase}/lib/qt-6/plugins/* $out/bin
    cp -r ${qt6.qtmultimedia}/lib/qt-6/plugins/* $out/bin
    cp -r ${ffmpeg}/bin/* $out/bin
    cp -r ${gnutls}/bin/* $out/bin
    cp -r --remove-destination ${srt}/bin/* $out/bin
    cp -r ${libffi}/bin/* $out/bin

    cat > $out/${pname}-installer-builder.iss <<'EOF'
      #define MyAppName "${pname}"
      #define MyAppVersion "1.5"
      #define MyAppPublisher "My Company, Inc."
      #define MyAppURL "https://www.example.com/"
      #define MyAppExeName "untitled.exe"

      [Setup]
      ; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
      ; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
      AppId={{89681292-40F7-4D19-952B-8D51D68A6FC8}
      AppName={#MyAppName}
      AppVersion={#MyAppVersion}
      ;AppVerName={#MyAppName} {#MyAppVersion}
      AppPublisher={#MyAppPublisher}
      AppPublisherURL={#MyAppURL}
      AppSupportURL={#MyAppURL}
      AppUpdatesURL={#MyAppURL}
      DefaultDirName={autopf}\{#MyAppName}
      DisableDirPage=yes
      DisableProgramGroupPage=yes
      ; Uncomment the following line to run in non administrative install mode (install for current user only.)
      ;PrivilegesRequired=lowest
      OutputBaseFilename={#MyAppName}-installer.exe
      OutputDir=${installerScriptBuilderOutput}
      Compression=lzma
      SolidCompression=yes
      WizardStyle=modern

      [Languages]
      Name: "english"; MessagesFile: "compiler:Default.isl"

      [Tasks]
      Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

      [Files]
      Source: "Z:$out\bin\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs
      ; NOTE: Don't use "Flags: ignoreversion" on any shared system files

      [Icons]
      Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
      Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

      [Run]
      Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
    EOF

    substituteInPlace $out/${pname}-installer-builder.iss \
      --replace "\$out\bin" "$out\bin" \
      --replace "/" "\\" \
      --replace "https:\\\\www.example.com\\" "https://www.example.com/"
  '';

  postFixup = ''
    echo "Converting Sym links to the actual file"
    for link in $(${buildPackages.findutils}/bin/find $out/bin -type l); do
      target="$(readlink -f "$link")"
      if [ -f "$target" ]; then
        cp --remove-destination "$target" "$link"
      fi
    done
  '';

  dontWrapQtApps = true;

}
