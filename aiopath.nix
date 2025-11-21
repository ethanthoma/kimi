{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  aiofile,
  anyio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiopath";
  version = "0.7.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rUudCa4I3fbTndBuewo1OTnolSjaVxwM1PP+BxrvrU8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofile
    anyio
  ];

  doCheck = false;

  pythonImportsCheck = [ "aiopath" ];

  meta = with lib; {
    description = "Async pathlib for Python";
    homepage = "https://github.com/alexdelorenzo/aiopath";
    license = licenses.agpl3Only;
    maintainers = [ ];
  };
}
