{
  lib,
  flake,
  fetchurl,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "planledger";
  version = "0.4.0";
  pyproject = true;

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/66/5e/49216f323098b9cfc20bd93cf4d0214470c5146108e00deaa38b5a6e424e/planledger-0.4.0.tar.gz";
    hash = "sha256-1JugGM6GryijijGXInM0SpUVts8/l9dV6y/21dJUsZs=";
  };

  nativeBuildInputs = [
    python3Packages.pythonRelaxDepsHook
    python3Packages.setuptools
    python3Packages."setuptools-scm"
    python3Packages.wheel
  ];

  pythonRelaxDeps = [ "ledgercore" ];

  propagatedBuildInputs = [
    flake.packages.${stdenv.hostPlatform.system}.ledgercore
    python3Packages.typer
    python3Packages.click
    python3Packages.pyyaml
    python3Packages."jinja2"
    python3Packages."markdown-it-py"
    python3Packages.tomli
  ];

  pythonImportsCheck = [ "planledger" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/planledger --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Durable project-state storage and CLI for coding workflows";
    homepage = "https://github.com/ledgerwerk/planledger";
    changelog = "https://github.com/ledgerwerk/planledger/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "planledger";
    platforms = platforms.unix;
  };
}
