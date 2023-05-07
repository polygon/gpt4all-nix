{ stdenv
, lib
, src
, version
, cmake
, qtquicktimeline
, qtsvg
, wrapQtAppsHook
}:

stdenv.mkDerivation {
  pname = "gpt4all-chat";
  inherit src version;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'set(CMAKE_INSTALL_PREFIX ''${CMAKE_BINARY_DIR}/install)' ""
  '';

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
  ];

  buildInputs = [
    qtquicktimeline
    qtsvg
  ];

  meta = with lib; {
    description = "Gpt4all-j chat";
    homepage = "https://github.com/nomic-ai/gpt4all-chat";
    license = licenses.mit;
    mainProgram = "chat";
  };
}
