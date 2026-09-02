{
  lib,
  flake,
  fetchFromGitHub,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication rec {
  pname = "releaseledger";
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ledgerwerk";
    repo = "releaseledger";
    rev = "v${version}";
    hash = "sha256-kXr0YP6vkc7ajcuShRGVxBP/NuVkMuxoYzhQx1YIoBI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
    python3Packages.tomli
    python3Packages.tomlkit
    python3Packages.filelock
  ];

  pythonImportsCheck = [ "releaseledger" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/releaseledger --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.category = "Utilities";

  meta = with lib; {
    description = "Durable release-state storage and CLI for coding workflows";
    homepage = "https://github.com/ledgerwerk/releaseledger";
    changelog = "https://github.com/ledgerwerk/releaseledger/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "releaseledger";
    platforms = platforms.unix;
  };
}
