addSDL2Path() {
    if [ -e "$1/include/SDL2" ]; then
        export SDL2_PATH="${SDL2_PATH-}${SDL2_PATH:+ }$1/include/SDL2"
    fi

    # Check if the bin directory contains any .dll files
    if [ "$(find "$1/bin" -name '*.dll' -print -quit)" ]; then
        export NIX_LDFLAGS="-L$1/bin ${NIX_LDFLAGS-}"
    fi
}

addEnvHooks "$hostOffset" addSDL2Path
