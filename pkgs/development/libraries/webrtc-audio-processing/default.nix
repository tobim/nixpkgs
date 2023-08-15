{ lib
, stdenv
, fetchFromGitLab
, darwin
, abseil-cpp
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "webrtc-audio-processing";
  version = "unstable-2023-08-14";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pulseaudio";
    repo = "webrtc-audio-processing";
    rev = "315b2222a858f3dd9edd2ca04c531ca66ef9b713";
    sha256 = "sha256-ExBZ/09eZiCuyv2xHHhto0VURm14hhzx530XritVbjA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    abseil-cpp
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices ]);

  patchPhase = ''
    # this is just incorrect upstream
    # see https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/issues/4
    substituteInPlace meson.build \
      --replace "absl_flags_registry" "absl_flags_reflection"
    '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace webrtc/base/checks.cc --replace 'defined(__UCLIBC__)' 1
  '';

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing";
    description = "A more Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    license = licenses.bsd3;
    # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/blob/master/webrtc/rtc_base/system/arch.h
    platforms = intersectLists platforms.unix (platforms.aarch64 ++ platforms.mips ++ platforms.riscv ++ platforms.x86);
    # attempts to inline 256bit AVX instructions on x86
    # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/issues/5
    broken = stdenv.isx86_32;
  };
}
