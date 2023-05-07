{ src 
, lib
, stdenv
, fetchFromGitHub
, cmake
, qmake
, qtquicktimeline
, qtsvg
, wrapQtAppsHook
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
    qmake
  ];

  buildInputs = [
    qtquicktimeline
    qtsvg
  ];


  meta = with lib; {
    description = "Gpt4all-j chat";
    homepage = "https://github.com/nomic-ai/gpt4all-chat";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
