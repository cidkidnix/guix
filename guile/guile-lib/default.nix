{ stdenv, lib, fetchurl, guile, pkg-config }:

stdenv.mkDerivation rec {
  pname = "guile-lib";
  version = "0.2.7";

  src = fetchurl {
    url = "https://download.savannah.nongnu.org/releases/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-5O87hF8SGILHwM8E+BocuP02DG9ktWuGjeVUYhT5BN4=";
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
    maintainers = with maintainers; [ cidkidnix ];
    platforms = platforms.all;
  };
}
