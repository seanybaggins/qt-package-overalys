{ qtModule
, qtbase
, zlib
, pkg-config
}:

qtModule {
  pname = "qtsvg";
  qtInputs = [ qtbase ];
  buildInputs = [ zlib ];
  nativeBuildInputs = [ pkg-config ];
}
