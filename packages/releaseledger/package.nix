{
  lib,
  flake,
  fetchPypi,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "taskledger";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B/XD++cmB1cF37Y47PN2mUQSGXFm9XzqntTujWiHj1A=";
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
    homepage = "https://github.com/holgern/taskledger";
    changelog = "https://github.com/holgern/taskledger/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "taskledger";
    platforms = platforms.unix;
  };
}
