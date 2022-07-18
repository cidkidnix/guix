{ stdenv, lib, fetchurl, guile, avahi, pkg-config }:

stdenv.mkDerivation rec {
  pname = "guile-avahi";
  version = "0.4";

  src = fetchurl {
    url = "https://download.savannah.nongnu.org/releases/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-ncwoEAWMyH2PqBofqOt6OJKyzAqHhvsW/ojSYKoLpmk=";
  };

  postConfigure = ''
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/objdir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ guile avahi ];

  meta = with lib; {
    description = "JSON Bindings for GNU Guile";
    homepage = "https://savannah.nongnu.org/projects/guile-json";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cidkidnix ];
    platforms = platforms.all;
  };
}
