{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "0.22.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "MoonshotAI";
    repo = "kosong";
    rev = version;
    hash = "sha256-pGNciRe8Fbt100esc2mPI5tFfkWB7UnlwODVBSlt9+c=";
  };

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

  doCheck = false;

  dontCheckRuntimeDeps = true;

  pythonImportsCheck = [ "kosong" ];

  meta = {
    description = "LLM abstraction layer for AI agent applications";
    homepage = "https://github.com/MoonshotAI/kosong";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ethanthoma ];
  };
}
