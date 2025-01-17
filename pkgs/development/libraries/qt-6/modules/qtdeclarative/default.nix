{
  qtModule,
  qtbase,
  qtlanguageserver,
  qtshadertools,
  openssl,
  stdenv,
  lib,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtdeclarative";

  propagatedBuildInputs = [
    qtbase
    qtlanguageserver
    qtshadertools
    openssl
  ];
  strictDeps = true;

  patches = [
    # prevent headaches from stale qmlcache data
    ./disable-disk-cache.patch
    # add version specific QML import path
    ./use-versioned-import-path.patch
  ];

  cmakeFlags =
    [
      "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderTools"
      # for some reason doesn't get found automatically on Darwin
      "-DPython_EXECUTABLE=${lib.getExe pkgsBuildBuild.python3}"
    ]
    # Conditional is required to prevent infinite recursion during a cross build
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    ];
}
