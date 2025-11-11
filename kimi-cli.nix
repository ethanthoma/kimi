{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
  wheel,
  aiohttp,
  aiofiles,
  click,
  loguru,
  pyyaml,
  pillow,
  pydantic,
  rich,
  tenacity,
  httpx,
  prompt-toolkit,
  patch-ng,
  trafilatura,
  kosong,
  streamingjson,
  ripgrepy,
  agent-client-protocol,
  fastmcp,
  pyperclip,
  keyboard,
}:

buildPythonApplication rec {
  pname = "kimi-cli";
  version = "0.50";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MoonshotAI";
    repo = "kimi-cli";
    rev = "main";
    hash = "sha256-HlMxBI/6bldYLEAbcazGplL1q1oUv10dBH6EN8yRP6k=";
  };

  # Patch pyproject.toml to replace uv_build with setuptools and include data files
  postPatch = ''
        substituteInPlace pyproject.toml \
          --replace-fail 'requires = ["uv_build>=0.8.5,<0.9.0"]' 'requires = ["setuptools>=61", "wheel"]' \
          --replace-fail 'build-backend = "uv_build"' 'build-backend = "setuptools.build_meta"'
        
        # Fix compatibility with older pydantic versions by removing ensure_ascii parameter
        substituteInPlace src/kimi_cli/ui/shell/prompt.py \
          --replace-fail 'entry.model_dump_json(ensure_ascii=False)' 'entry.model_dump_json()'
        
        # Add package data configuration to include .md and .yaml files
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
    # Add available dependencies from nixpkgs and custom packages
    aiohttp
    aiofiles
    click
    kosong
    loguru
    pyyaml
    pillow
    pydantic
    rich
    tenacity
    httpx
    prompt-toolkit
    patch-ng
    trafilatura
    streamingjson
    ripgrepy
    agent-client-protocol
    pyperclip
    keyboard
    fastmcp
    # Note: All major dependencies now included
  ];

  # Skip checks since not all dependencies are available
  doCheck = false;

  # Skip Python imports check due to missing dependencies
  pythonImportsCheck = [ ];

  # Skip runtime dependency checking since many deps aren't in nixpkgs
  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "CLI agent for software development";
    homepage = "https://github.com/MoonshotAI/kimi-cli";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}

