{
  lib,
  flake,
  fetchPypi,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "repairledger";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oCuvH6AmQ3yBaAuFA5HNlLGsz+quv5yuknzJkJt1xpQ=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages."setuptools-scm"
    python3Packages.wheel
  ];

  propagatedBuildInputs = [
    flake.packages.${stdenv.hostPlatform.system}.ledgercore
    python3Packages.typer
    python3Packages.pyyaml
    python3Packages.tomli
  ];

  pythonImportsCheck = [ "repairledger" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/repairledger --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Durable repair-observation ledger and CLI for agent-discovered tool failures";
    homepage = "https://github.com/holgern/repairledger";
    changelog = "https://github.com/holgern/repairledger/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "repairledger";
    platforms = platforms.unix;
  };
}
