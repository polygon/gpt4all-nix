{ src 
, lib
, stdenv
, cmake
, fmt
, qtwayland
, qtquicktimeline
, qtsvg
, qthttpserver
, qtwebengine
, qt5compat
, shaderc
, vulkan-headers
, wayland
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

  patches = [ ];

  buildInputs = [
    fmt
    cmake
    qtwayland
    qtquicktimeline
    qtsvg
    qthttpserver
    qtwebengine
    qt5compat
    shaderc
    vulkan-headers
    wayland
  ];

  cmakeFlags = lib.optionals withAvx2 [ "-DGPT4ALL_AVX_ONLY=ON" "-DKOMPUTE_OPT_USE_BUILT_IN_VULKAN_HEADER=OFF" "-DKOMPUTE_OPT_DISABLE_VULKAN_VERSION_CHECK=ON" "-DKOMPUTE_OPT_USE_BUILT_IN_FMT=OFF" ];

  

  setSourceRoot = "sourceRoot=`pwd`/source/gpt4all-chat";

  meta = with lib; {
    description = "Gpt4all-j chat";
    homepage = "https://github.com/nomic-ai/gpt4all-chat";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
