{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ripgrep,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ripgrepy";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "securisec";
    repo = "ripgrepy";
    tag = version;
    hash = "sha256-+Q9O6sLXgdhjxN6+cTJvNhVg6cr0jByETJrlpnc+FEQ=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ ripgrep ];

  # tests/ directory contains example code, not actual pytest tests
  doCheck = false;

  pythonImportsCheck = [ "ripgrepy" ];

  meta = {
    description = "Python interface to ripgrep";
    homepage = "https://github.com/securisec/ripgrepy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ethanthoma ];
  };
}
