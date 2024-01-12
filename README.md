# Intro
I need to get qtbase and qtmultimeida cross compiling to mingw32 for my job. I
want to upstream these changes but sometimes the review process in nixpkgs is taking
longer than I have time for. This repo exists so I can iterate quickly on
getting cross compilation working for nixpkgs and so other memembers of the
community can leverage my work and hopefully help me get a few more packages
cross compiling :)

## Building
```
nix build '.#pkgs.pkgsCross.mingw32.qtbase'
nix build '.#pkgs.pkgsCross.mingw32.qtapp-example'
nix build '.#pkgs.pkgsCross.mingw32.qtmultimeida'
```

# Status
- qtbase: Working within overlay. Not fully ported to nixpkgs
- qtapp-example: Working within overlay. May never be ported to nixpkgs
- qtmultimeida: Not working within overlay. In progress.

# Issue tracking
- https://github.com/NixOS/nixpkgs/issues/274274
- https://github.com/NixOS/nixpkgs/issues/272538
