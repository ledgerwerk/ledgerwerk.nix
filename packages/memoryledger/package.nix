{
  lib,
  flake,
  fetchPypi,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "memoryledger";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-seuflLIMZliS9cJT0qeKMv598YzT8dFITarJdE6r37s=";
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

  pythonImportsCheck = [ "memoryledger" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/memoryledger --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Auditable long-term project memory ledger and AGENTS.md renderer";
    homepage = "https://github.com/ledgerwerk/memoryledger";
    changelog = "https://github.com/ledgerwerk/memoryledger/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "memoryledger";
    platforms = platforms.unix;
  };
}
