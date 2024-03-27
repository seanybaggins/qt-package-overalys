# Intro
I need to get qtbase and qtmultimeida cross compiling to mingw32 for my job. I
want to upstream these changes but sometimes the review process in nixpkgs is taking
longer than I have time for. This repo exists so I can iterate quickly on
getting cross compilation working for nixpkgs and so other memembers of the
community can leverage my work and hopefully help me get a few more packages
cross compiling :)

## Building
Make sure you have you have the nix package manager installed with flakes
enabled. You can install the nix pakcage manager with flakes enabled on
non-nixos systems by running
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
You can then build the example application by running 
```
nix build 'github:seanybaggins/qt-package-overalys#pkgs.pkgsCross.mingw32.qtapp-example'
```
See the result/installer directory for the windows installer to run wihtin your
windows environment.

## Expected behavior of qtapp-example
On launch before button is pressed
![qtapp-example-beforeButtonPress](./images/qtapp-example-beforeButtonPress.png)

After button press, a short video of a toy will play
![](./images/qtapp-example-afterButtonPress.png)

## Status
- qtbase: Working within overlay. Not fully ported to nixpkgs
- qtmultimeida: Working within overlay. Not fully ported to nixpkgs
- qtapp-example: Working within overlay. Utilizes both qtbase and qtmultimeida.
    May never be ported to nixpkgs but serves as a good example of the
    requirments needed to package a windows application that wants to use a
    traditional installer such as inno setup.

## Issue tracking
- https://github.com/NixOS/nixpkgs/issues/274274
- https://github.com/NixOS/nixpkgs/issues/272538

## Recommneded process to upstream to nixpkgs 
1. Clone nixpkgs master branch
2. Try and build qtbase or qtmultimeida within nixpkgs
3. You should get a build error for one of the packages. Use this as the
   starting package to port changes over. Once things are compiling, open a PR
   for that individual package.
