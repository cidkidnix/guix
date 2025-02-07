{ lib, newScope, guile_3_0, gnutls, overrides ? (self: super: { }) }:

let
  packages = self:
    let
      callPackage = newScope self;

      guile-gnutls = (gnutls.override {
        guile = guile_3_0;
        guileBindings = true;
      }).overrideAttrs (attrs: {
        configureFlags = [
          "--with-guile-site-dir=\${out}/share/guile/site"
          "--with-guile-site-ccache-dir=\${out}/share/guile/ccache"
          "--with-guile-extension-dir=\${out}/lib/guile/extensions"
        ];
      });
    in
    {
      inherit guile-gnutls;

      guile = guile_3_0;

      guile-gcrypt = callPackage ./guile-gcrypt { };

      bytestructures = callPackage ./bytestructures { };

      lzlib = callPackage ./lzlib { };

      guile-avahi = callPackage ./guile-avahi { };

      guile-lib = callPackage ./guile-lib { };

      guile-semver = callPackage ./guile-semver { };

      guile-git = callPackage ./guile-git { };

      guile-json = callPackage ./guile-json { };

      guile-lzlib = callPackage ./guile-lzlib { };

      guile-sqlite3 = callPackage ./guile-sqlite3 { };

      guile-ssh = callPackage ./guile-ssh { };

      guile-zlib = callPackage ./guile-zlib { };

      guile-zstd = callPackage ./guile-zstd { };
    };
in
lib.fix' (lib.extends overrides packages)
