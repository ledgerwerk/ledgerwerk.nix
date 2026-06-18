{
  lib,
  flake,
  fetchPypi,
  python3Packages,
  stdenv,
}:

let
  fuzzysearch = python3Packages.buildPythonPackage rec {
    pname = "fuzzysearch";
    version = "0.8.1";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-5fUJYsaxw9/GyM39XiYEg4yVyxARjkyrUY5SkungscY=";
    };

    nativeBuildInputs = [
      python3Packages.setuptools
      python3Packages.wheel
    ];

    propagatedBuildInputs = [
      python3Packages.attrs
    ];

    pythonImportsCheck = [ "fuzzysearch" ];

    meta = with lib; {
      description = "Fuzzy search: find approximate subsequence matches in long text or data";
      homepage = "https://github.com/taleinat/fuzzysearch";
      license = licenses.mit;
      sourceProvenance = with sourceTypes; [ fromSource ];
      platforms = platforms.unix;
    };
  };
in
python3Packages.buildPythonApplication rec {
  pname = "wikimason";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xV4bKAmJzdKqaTzc9tjBxo2Kehdm9wDSq7xe7avLh9M=";
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
    python3Packages.rapidfuzz
    fuzzysearch
    python3Packages.tomli
  ];

  pythonImportsCheck = [ "wikimason" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/wikimason --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Filesystem-backed CLI toolkit for building and maintaining an LLM wiki";
    homepage = "https://github.com/ledgerwerk/wikimason";
    changelog = "https://github.com/ledgwerk/wikimason/releases/tag/v${version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "wikimason";
    platforms = platforms.unix;
  };
}
