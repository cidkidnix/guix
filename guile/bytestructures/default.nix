{ stdenv, lib, fetchFromGitHub, guile, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "scheme-bytestructures";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "TaylanUB";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Wvs288K8BVjUuWvvzpDGBwOxL7mAXjVtgIwJAsQd0L4=";
  };

  postConfigure = ''
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/godir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ guile ];

  meta = with lib; {
    description = "Structured access to bytevector contents";
    homepage = "https://github.com/TaylanUB/scheme-bytestructures";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bqv ];
    platforms = platforms.all;
  };
}
