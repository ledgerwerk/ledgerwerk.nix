{
  lib,
  flake,
  fetchPypi,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "releaseledger";
  version = "0.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-87wjDWLgLLvKMLU/1Z5FeGEnWTiAn01oJGHqR9aDY/M=";
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
    python3Packages."jinja2"
    python3Packages.tomli
    python3Packages.tomlkit
    python3Packages.filelock
  ];

  pythonImportsCheck = [ "releaseledger" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/releaseledger --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Durable release-state storage and CLI for coding workflows";
    homepage = "https://github.com/ledgerwerk/releaseledger";
    changelog = "https://github.com/ledgerwerk/releaseledger/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "releaseledger";
    platforms = platforms.unix;
  };
}
