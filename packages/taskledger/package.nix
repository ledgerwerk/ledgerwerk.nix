{
  lib,
  flake,
  fetchFromGitHub,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "taskledger";
  version = "0.6.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ledgerwerk";
    repo = "taskledger";
    rev = "v${version}";
    hash = "sha256-gEd9WLEXJ+Y/rd4uy2EEwuxUi/rCnJMqtMgr2dUSSow=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages."setuptools-scm"
    python3Packages.wheel
    python3Packages.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "packaging" ];

  propagatedBuildInputs = [
    flake.packages.${stdenv.hostPlatform.system}.ledgercore
    python3Packages.typer
    python3Packages.click
    python3Packages.packaging
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
