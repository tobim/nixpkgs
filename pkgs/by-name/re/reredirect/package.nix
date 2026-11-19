{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reredirect";
  version = "unstable-2026-07-06";

  src = fetchFromGitHub {
    owner = "jerome-pouiller";
    repo = "reredirect";
    rev = "fd551baec5477df5e485c75c5c9e76319363a254";
    sha256 = "sha256-+5vrgO0nAtW5QukpbTuQHIrVj0HQwVb2ipitg0Ks9hk=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postFixup = ''
    substituteInPlace ${placeholder "out"}/bin/relink \
      --replace-fail "reredirect" "${placeholder "out"}/bin/reredirect"
  '';

  meta = {
    description = "Tool to dynamically redirect outputs of a running process";
    homepage = "https://github.com/jerome-pouiller/reredirect";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tobim ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
