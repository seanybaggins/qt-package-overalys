{ qtModule
, qtdeclarative
, qtbase
, qttools
}:

qtModule {
  pname = "qttodolist";
  # avoid fix-qt-builtin-paths hook substitute QT_INSTALL_DOCS to qtdoc's path
  postPatch = ''
    for file in $(grep -rl '$QT_INSTALL_DOCS'); do
      substituteInPlace $file \
          --replace '$QT_INSTALL_DOCS' "${qtbase}/share/doc"
    done
  '';
  nativeBuildInputs = [ qttools ];
  qtInputs = [ qtdeclarative ];
  cmakeFlags = [
    "-DCMAKE_MESSAGE_LOG_LEVEL=STATUS"
  ];
  dontUseNinjaBuild = true;
  buildFlags = [ "todolist" ];
  dontUseNinjaInstall = true;
  installFlags = [ "install_docs" ];
  outputs = [ "out" ];
}
