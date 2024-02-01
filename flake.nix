{
  description = "A flake for lightdeck studio development and build environment";

  inputs = {
    nixpkgs.url = "github:seanybaggins/nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        overlays = [ (import ./nix/overlays) ];
        pkgs = import nixpkgs
          {
            inherit system overlays;
            config = { };
          };
      in
      {
        packages.pkgs = pkgs;

        #devShell = pkgs.mkShell {
        #  packages = with pkgs; [
        #    qt6.full
        #    qtcreator
        #    gnumake
        #    gcc
        #    gdb
        #    cmake
        #  ];
        #};
      }
    );
}
