{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, hatch-vcs
, packaging
, tomlkit
, returns
, jinja2
, dunamai
}:

buildPythonPackage rec {
  pname = "uv-dynamic-versioning";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "uv_dynamic_versioning";
    inherit version;
    hash = "sha256-euyJd6L9iGWyBbY/s5tpKIRV4AJ4AryytiAwJtlXuyU=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    packaging
    tomlkit
    returns
    jinja2
    dunamai
  ];

  # Skip checks since this is just a build tool
  doCheck = false;
  pythonImportsCheck = [ ];
  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "Dynamic versioning plugin for uv";
    homepage = "https://pypi.org/project/uv-dynamic-versioning/";
    license = licenses.mit;
    maintainers = [ ];
  };
}