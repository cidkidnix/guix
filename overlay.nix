final: prev:
let guilePackages = prev.callPackages ./guile { };
in rec {
  guix = prev.callPackage ./package { inherit guilePackages; };
  inherit (guilePackages)
    guile-gnutls guile-gcrypt guile-git guile-json guile-sqlite3
    guile-ssh guile-zstd guile-avahi guile-semver guile-lib;
  scheme-bytestructures = guilePackages.bytestructures;
}
