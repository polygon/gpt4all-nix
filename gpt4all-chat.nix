{ src 
, lib
, stdenv
, cmake
, qtwayland
, qtquicktimeline
, qtsvg
, wrapQtAppsHook
, withAvx2 ? true
}:

stdenv.mkDerivation {
  pname = "gpt4all-chat";
  version = "nightly";

  inherit src;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'set(CMAKE_INSTALL_PREFIX ''${CMAKE_BINARY_DIR}/install)' ""
  '';

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
  ];

  buildInputs = [
    qtwayland
    qtquicktimeline
    qtsvg
  ];

  cmakeFlags = lib.optionals withAvx2 [ "-DGPT4ALL_AVX_ONLY=ON" ];

  setSourceRoot = "sourceRoot=`pwd`/source/gpt4all-chat";

  meta = with lib; {
    description = "Gpt4all-j chat";
    homepage = "https://github.com/nomic-ai/gpt4all-chat";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
