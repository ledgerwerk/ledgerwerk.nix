{
  lib,
  flake,
  fetchPypi,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "documentledger";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3ZHuV/tPF/hI7QMYjZoXwwi971n8JNmGsmNx4Ae3e5A=";
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
    python3Packages.tomli
  ];

  pythonImportsCheck = [ "documentledger" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/documentledger --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Documentation freshness ledger for coding-agent workflows";
    homepage = "https://github.com/ledgerwerk/documentledger";
    changelog = "https://github.com/ledgerwerk/documentledger/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "documentledger";
    platforms = platforms.unix;
  };
}
