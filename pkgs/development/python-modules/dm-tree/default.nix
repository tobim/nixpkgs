{ stdenv
, abseil-cpp
, absl-py
, attrs
, buildPythonPackage
, cmake
, fetchFromGitHub
, lib
, numpy
, pybind11
, wrapt
}:

buildPythonPackage rec {
  pname = "dm-tree";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "tree";
    rev = "refs/tags/${version}";
    hash = "sha256-VvSJTuEYjIz/4TTibSLkbg65YmcYqHImTHOomeorMJc=";
  };

  patches = [
    ./cmake.patch
  ];

  # Build with c++17 to align with abseil.
  postPatch = ''
    substituteInPlace tree/CMakeLists.txt \
      --replace 'CMAKE_CXX_STANDARD 14' 'CMAKE_CXX_STANDARD 17'
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pybind11
  ];

  buildInputs = [
    abseil-cpp
    pybind11
  ];

  nativeCheckInputs = [
    absl-py
    attrs
    numpy
    wrapt
  ];

  pythonImportsCheck = [ "tree" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Tree is a library for working with nested data structures.";
    homepage = "https://github.com/deepmind/tree";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ndl ];
  };
}
