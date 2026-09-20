{
  lib,
  flake,
  fetchurl,
  python3Packages,
}:

let
  typesafe-sdk = python3Packages.buildPythonPackage rec {
    pname = "typesafe-sdk";
    version = "0.7.0";
    pyproject = true;

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/28/e2/ac317772d4d5cfabf3cecdeacd83cc838523e240bb4e1cf256837e6005bb/typesafe_sdk-0.7.0.tar.gz";
      hash = "sha256-kw1C/XPP7W8lvMrkiM4PMPYEPq7dhoLvWXNOeauUqHY=";
    };

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail '  "License :: OSI Approved :: MIT License",' "" \
        --replace-fail 'requires = ["uv_build>=0.12.5,<0.13"]' 'requires = ["setuptools"]' \
        --replace-fail 'build-backend = "uv_build"' 'build-backend = "setuptools.build_meta"'
    '';

    nativeBuildInputs = [
      python3Packages.setuptools
      python3Packages.wheel
    ];

    propagatedBuildInputs = [
      python3Packages.httpx2
      python3Packages.pydantic
      python3Packages.pydantic-core
      python3Packages.tenacity
      python3Packages.typing-extensions
    ];

    pythonImportsCheck = [ "typesafe_sdk" ];

    meta = with lib; {
      description = "Python SDK for TypeSafe AI API";
      homepage = "https://typesafe.ai";
      license = licenses.mit;
      sourceProvenance = with sourceTypes; [ fromSource ];
      platforms = platforms.unix;
    };
  };
in
python3Packages.buildPythonApplication rec {
  pname = "pyjev";
  version = "0.1.0";
  pyproject = true;

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/46/a5/8059efe99d9c340f5fb700e975a447c1ebcccf1c005eab6ff53b31f98943/pyjev-0.1.0.tar.gz";
    hash = "sha256-SNtkxCqnKy2oRAvSH2JKnWkeG19iq4gwCGan0FPABR8=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages."setuptools-scm"
    python3Packages.wheel
  ];

  propagatedBuildInputs = [
    typesafe-sdk
    python3Packages.typer
    python3Packages.keyring
    python3Packages.tomli
  ];

  pythonImportsCheck = [ "pyjev" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/pyjev --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Reusable, confidence-aware Jev decisions for Python and the shell";
    homepage = "https://github.com/ledgerwerk/pyjev";
    changelog = "https://github.com/ledgerwerk/pyjev/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "pyjev";
    platforms = platforms.unix;
  };
}
