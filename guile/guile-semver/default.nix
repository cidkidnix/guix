{ stdenv, lib, fetchgit, guile, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "guile-semver";
  version = "v0.1.1";

  src = fetchgit {
    url = "https://git.ngyro.com/guile-semver";
    rev = version;
    sha256 = "sha256-PNfbF77hZ4NK/bqKtLfiS/fV5Ru+6r+tunqAkwuz2UE=";
  };

  preAutoreconf = ''
    ./bootstrap
  '';

  postConfigure = ''
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/objdir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
  '';

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ guile ];

  meta = with lib; {
    description = "JSON Bindings for GNU Guile";
    homepage = "https://savannah.nongnu.org/projects/guile-json";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bqv ];
    platforms = platforms.all;
  };
}
