{
  lib,
  flake,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "ledgercore";
  version = "0.6.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m5lg5cdeGnYxwiOgxcK7pXZTcF6KPaV6jw/gVA0xdZU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'hatchling<1.28' 'hatchling'
  '';

  nativeBuildInputs = [
    python3Packages.hatchling
    python3Packages.hatch-vcs
  ];

  propagatedBuildInputs = [
    python3Packages.pyyaml
    python3Packages.platformdirs
    python3Packages.tomlkit
    python3Packages.uuid6
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
