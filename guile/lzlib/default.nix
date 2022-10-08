{ stdenv, lib, fetchurl, guile, libgcrypt, autoreconfHook, pkg-config, texinfo, }:
# https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/compression.scm#n1816
stdenv.mkDerivation rec {
  pname = "lzlib";
  version = "1.13";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/lzip/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-oatY8xSLpLJnTpOEOBZgQhN6knW+10cwZkGs/dyf+4A=";
  };

  # nativeBuildInputs = [ pkgconfig ];
  # buildInputs = [ ];

  meta = with lib; {
    description = "lzlib is a GNU Guile library providing bindings to lzlib";
    homepage = "https://notabug.org/guile-lzlib/guile-lzlib";
    # license = licenses.bsd-2;
    maintainers = with maintainers; [ emiller88 ];
    platforms = platforms.all;
  };
}
