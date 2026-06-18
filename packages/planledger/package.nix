{
  lib,
  flake,
  fetchPypi,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "planledger";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZL1YuOMA/+GYiiXNUJ/5AH45RfJAK7o637+wd0/T7Go=";
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
