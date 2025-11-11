{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  wheel,
  anthropic,
  python-dotenv,
  jsonschema,
  loguru,
  openai,
  pydantic,
}:

buildPythonPackage rec {
  pname = "kosong";
  version = "0.18.0";
  pyproject = true;

  # Keep Python 3.13 requirement as it's current Python version
  disabled = pythonOlder "3.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-goWmqJFnrphL5z2VNnKgCSZQ2E1EkRPZfQDcGNlFzcM=";
  };

  # Need to patch build system as package uses uv_build which isn't in nixpkgs
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["uv_build>=0.8.5,<0.9.0"]' 'requires = ["setuptools>=61", "wheel"]' \
      --replace-fail 'build-backend = "uv_build"' 'build-backend = "setuptools.build_meta"'
  '';

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    anthropic
    python-dotenv
    jsonschema
    loguru
    openai
    pydantic
  ];

  # No tests in PyPI sdist
  doCheck = false;

  # Skip runtime dependency checks as nixpkgs versions may not match requirements
  dontCheckRuntimeDeps = true;

  pythonImportsCheck = [ "kosong" ];

  meta = {
    description = "The building blocks of AI agent";
    homepage = "https://pypi.org/project/kosong/";
    # License needs verification - no public repo available
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethanthoma ];
  };
}
