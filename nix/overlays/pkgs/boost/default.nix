{ path, callPackage, fetchurl, ... } @ args:

callPackage "${path}/pkgs/development/libraries/boost/generic.nix" (args // rec {
  version = "1.71.0";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/boost/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2"
      "https://boostorg.jfrog.io/artifactory/main/release/${version}/source/boost_${builtins.replaceStrings ["."] ["_"] version}.tar.bz2"
    ];
    # SHA256 from http://www.boost.org/users/history/version_1_71_0.html
    sha256 = "d73a8da01e8bf8c7eda40b4c84915071a8c8a0df4a6734537ddde4a8580524ee";
  };

  patches = [ ./pthread-stack-min-fix.patch ];
})
