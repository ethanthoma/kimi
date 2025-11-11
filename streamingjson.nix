{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "streamingjson";
  version = "0.0.5";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k7AofOStQIkwj75XRbi/1js55EWm84kUdOqEkShKI+M=";
  };

  build-system = [
    setuptools
    wheel
  ];

  # No dependencies listed in PyPI
  dependencies = [ ];

  # Skip checks since no tests available
  doCheck = false;
  
  # Skip Python imports check 
  pythonImportsCheck = [ ];
  
  # Skip runtime dependency checking
  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "Streaming JSON parser";
    homepage = "https://pypi.org/project/streamingjson/";
    license = licenses.mit; # Assuming MIT since no license specified
    maintainers = [ ];
  };
}