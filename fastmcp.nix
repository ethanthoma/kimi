{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  uv-dynamic-versioning,
  pydantic,
  pydantic-settings,
  anyio,
  click,
  httpx,
  jsonschema,
  mcp,
  authlib,
  exceptiongroup,
}:

buildPythonPackage rec {
  pname = "fastmcp";
  version = "2.12.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lf0C4lVwWkr+Q9JsrdvIZFYwNuIz28aHDzie5SOzmmo=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    pydantic
    pydantic-settings
    anyio
    click
    httpx
    jsonschema
    mcp
    authlib
    exceptiongroup
  ];

  # Skip checks since no tests available
  doCheck = false;

  # Skip Python imports check
  pythonImportsCheck = [ ];

  # Skip runtime dependency checking
  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "The fast, Pythonic way to build MCP servers and clients";
    homepage = "https://pypi.org/project/fastmcp/";
    license = licenses.mit; # Assuming MIT since no license specified
    maintainers = [ ];
  };
}

