{
  lib,
  flake,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "ledgercore";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C2S/zoBAzfjSybvQiGmGAp3W8LxOXy9I2ymuvon0ikk=";
  };

  nativeBuildInputs = [
    python3Packages.hatchling
    python3Packages.hatch-vcs
  ];

  propagatedBuildInputs = [
    python3Packages.pyyaml
  ];

  pythonImportsCheck = [ "ledgercore" ];

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Shared core library for ledgerwerk tools";
    homepage = "https://github.com/ledgerwerk/ledgercore";
    changelog = "https://github.com/ledgerwerk/ledgercore/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "ledgercore";
    platforms = platforms.unix;
  };
}
