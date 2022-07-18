{ stdenv, lib, fetchgit, guile, avahi, pkg-config }:

stdenv.mkDerivation rec {
  pname = "guile-avahi";
  version = "0.4";

  src = fetchgit {
    url = "mirror://savannah/guile-avahi/${pname}-${version}.tar.gz";
    sha256 = lib.fakeHash;
  };

  postConfigure = ''
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/objdir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
  '';

  nativeBuildInputs = [ pkg-config texinfo ];
  buildInputs = [ guile avahi ];

  meta = with lib; {
    description = "JSON Bindings for GNU Guile";
    homepage = "https://savannah.nongnu.org/projects/guile-json";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bqv ];
    platforms = platforms.all;
  };
}
