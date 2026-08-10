{
  lib,
  flake,
  fetchPypi,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "taskledger";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ar/j3IusiIVE+dhL+qm+yXMLiENaypyzXlfKV0PNJoo=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages."setuptools-scm"
    python3Packages.wheel
  ];

  propagatedBuildInputs = [
    flake.packages.${stdenv.hostPlatform.system}.ledgercore
    python3Packages.typer
    python3Packages.click
    python3Packages.pyyaml
    python3Packages.tomlkit
    python3Packages.filelock
    python3Packages.tomli
  ];

  pythonImportsCheck = [ "taskledger" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/taskledger --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Durable project-state storage and CLI for coding workflows";
    homepage = "https://github.com/ledgerwerk/taskledger";
    changelog = "https://github.com/ledgerwerk/taskledger/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "taskledger";
    platforms = platforms.unix;
  };
}
