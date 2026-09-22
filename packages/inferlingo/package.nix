{
  lib,
  flake,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "inferlingo";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IOK9hbToIizWksg3iSBeii6lMhzzsZhXNmRcFbb1d00=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages."setuptools-scm"
    python3Packages.wheel
  ];

  propagatedBuildInputs = [
    python3Packages.typer
  ];

  pythonImportsCheck = [ "inferlingo" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/inferlingo --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "A small model-neutral logic engine for natural-language facts, rules, and semantic unification";
    homepage = "https://github.com/ledgerwerk/inferlingo";
    changelog = "https://github.com/ledgerwerk/inferlingo/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "inferlingo";
    platforms = platforms.unix;
  };
}
