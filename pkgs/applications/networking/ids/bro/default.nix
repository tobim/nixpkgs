{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, perl, zlib, file, curl
, libmaxminddb, gperftools, ncurses, python, swig, caf, rocksdb }:

stdenv.mkDerivation rec {
  pname = "bro";
  version = "2.6.2";

  src = fetchurl {
    url = "https://www.zeek.org/downloads/bro-${version}.tar.gz";
    sha256 = "19n0xai1mndx2i28q9cnszam57r6p6zqhprxxfpxh7bv7xpqgxkd";
  };

  nativeBuildInputs = [ cmake flex bison file ];
  buildInputs = [ openssl libpcap perl zlib curl libmaxminddb ncurses gperftools python swig caf rocksdb ];

  cmakeFlags = [
   "-DCAF_ROOT_DIR=${caf}"
  ];

  # Future work: define these in the above array via placeholders
  preConfigure = ''
    cmakeFlags+=" -DBROKER_PYTHON_PREFIX=$out"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Powerful network analysis framework much different from a typical IDS";
    homepage = https://www.zeek.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub tobim ];
    platforms = with platforms; linux;
  };
}
