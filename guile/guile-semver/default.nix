{ stdenv, lib, fetchurl, guile, avahi, pkg-config }:

stdenv.mkDerivation rec {
  pname = "guile-semver";
  version = "v0.1.1";

  src = fetchgit {
    url = "https://git.ngyro.com/guile-semver.git";
    rev = version;
    sha256 = lib.fakeHash;
  };

  postConfigure = ''
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/objdir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ guile ];

  meta = with lib; {
    description = "JSON Bindings for GNU Guile";
    homepage = "https://savannah.nongnu.org/projects/guile-json";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bqv ];
    platforms = platforms.all;
  };
}
