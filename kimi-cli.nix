{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
  wheel,
  agent-client-protocol,
  aiofiles,
  aiohttp,
  typer,
  kosong,
  loguru,
  patch-ng,
  prompt-toolkit,
  pillow,
  pyperclip,
  pyyaml,
  rich,
  ripgrepy,
  streamingjson,
  trafilatura,
  tenacity,
  fastmcp,
  pydantic,
  httpx,
}:

buildPythonApplication {
  pname = "kimi-cli";
  version = "0.50";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MoonshotAI";
    repo = "kimi-cli";
    rev = "main";
    hash = "sha256-lQ8/2ivMvoBYNvn47cf+Paj1UD+GjmRJr2xcpivmTRE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["uv_build>=0.8.5,<0.9.0"]' 'requires = ["setuptools>=61", "wheel"]' \
      --replace-fail 'build-backend = "uv_build"' 'build-backend = "setuptools.build_meta"'

    substituteInPlace src/kimi_cli/ui/shell/prompt.py \
      --replace-fail 'entry.model_dump_json(ensure_ascii=False)' 'entry.model_dump_json()'

    cat >> pyproject.toml << 'EOF'

[tool.setuptools.package-data]
"*" = ["*.md", "*.yaml", "*.yml"]

[tool.setuptools.packages.find]
where = ["src"]
EOF
  '';

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    agent-client-protocol
    aiofiles
    aiohttp
    typer
    kosong
    loguru
    patch-ng
    prompt-toolkit
    pillow
    pyperclip
    pyyaml
    rich
    ripgrepy
    streamingjson
    trafilatura
    tenacity
    fastmcp
    pydantic
    httpx
  ];

  doCheck = false;

  pythonImportsCheck = [ ];

  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "CLI agent for software development";
    homepage = "https://github.com/MoonshotAI/kimi-cli";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
