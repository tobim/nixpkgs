{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, static ? stdenv.hostPlatform.isStatic
 # TODO: default to `null` after all major toolchains have been upgraded to
 # versions that default to c++17. Only LLVM/clang is missing.
 # https://github.com/NixOS/nixpkgs/pull/241692.
, cxxStandard ? "17"
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abseil-cpp";
  version = "20230125.3";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-PLoI7ix+reUqkZ947kWzls8lujYqWXk9A9a55UcfahI=";
  };

  cmakeFlags = [
    "-DABSL_BUILD_TEST_HELPERS=ON"
    "-DABSL_USE_EXTERNAL_GOOGLETEST=ON"
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
    "-DCMAKE_CXX_STANDARD=${cxxStandard}"
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gtest ];

  meta = with lib; {
    description = "An open-source collection of C++ code designed to augment the C++ standard library";
    homepage = "https://abseil.io/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.andersk ];
  };
})
