{ stdenv
, pkgs
, lib
, fetchurl
, fetchgit
, autoconf
, gettext
, automake
, texinfo
, help2man
, glibcLocales
, autoreconfHook
, pkg-config
, makeWrapper
, zlib
, zstd
, bzip2
, guile_3_0
, guilePackages
, perl534Packages
, storeDir ? null
, stateDir ? null
}:

stdenv.mkDerivation rec {
  pname = "guix";
  version = "1.4.0";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/guix.git";
    rev = "6913c26d116c8fe828a2ff91140be6a40509bdd9";
    sha256 = "sha256-XJpqgO8dMoRCdZf3V6w7TwnRbCfZAdIQSqYVTRp4xXo=";
    fetchSubmodules = true;
  };

  preAutoreconf = ''
    ./bootstrap
  '';

  postConfigure = ''
    sed -i '/guilemoduledir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/guileobjectdir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
  '';

  modules = with guilePackages;
    lib.forEach [
      guile-gcrypt
      guile-git
      guile-json
      guile-lzlib
      guile-sqlite3
      guile-ssh
      guile-gnutls
      guile-zlib
      guile-zstd
      bytestructures
    ]

      (m: (m.override { guile = guile_3_0; }).out);

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    automake
    autoconf
    gettext
    automake
    texinfo
    glibcLocales
    autoreconfHook
    help2man
    perl534Packages.Po4a
  ];
  buildInputs = [ zlib bzip2 zstd ] ++ modules;
  propagatedBuildInputs = [ guile_3_0 ];

  GUILE_LOAD_PATH =
    let
      guilePath = [
        "\${out}/share/guile/site"
        "${guilePackages.guile-gnutls.out}/lib/guile/extensions"
      ] ++ (lib.concatMap (module: [ "${module}/share/guile/site" ]) modules);
    in
    "${lib.concatStringsSep ":" guilePath}";
  GUILE_LOAD_COMPILED_PATH =
    let
      guilePath = [
        "\${out}/share/guile/ccache"
        "${guilePackages.guile-gnutls.out}/lib/guile/extensions"
      ] ++ (lib.concatMap (module: [ "${module}/share/guile/ccache" ]) modules);
    in
    "${lib.concatStringsSep ":" guilePath}";

  configureFlags = [ ]
    ++ lib.optional (storeDir != null) "--with-store-dir=${storeDir}"
    ++ lib.optional (stateDir != null) "--localstatedir=${stateDir}";

  postInstall = ''
    wrapProgram $out/bin/guix \
      --prefix GUILE_LOAD_PATH : "${GUILE_LOAD_PATH}" \
      --prefix GUILE_LOAD_COMPILED_PATH : "${GUILE_LOAD_COMPILED_PATH}"

    wrapProgram $out/bin/guix-daemon \
      --prefix GUILE_LOAD_PATH : "${GUILE_LOAD_PATH}" \
      --prefix GUILE_LOAD_COMPILED_PATH : "${GUILE_LOAD_COMPILED_PATH}"
  '';

  passthru = { inherit guile_3_0; };

  meta = with lib; {
    description =
      "A transactional package manager for an advanced distribution of the GNU system";
    homepage = "https://guix.gnu.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bqv ];
    platforms = platforms.linux;
  };
}
