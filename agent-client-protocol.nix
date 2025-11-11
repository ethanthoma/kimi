{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "agent-client-protocol";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "psiace";
    repo = "agent-client-protocol-python";
    tag = version;
    hash = "sha256-w9WH4sdHvDsiwzkVdKy9SROzFZwLCC8SUJVI8TLOKaY=";
  };

  build-system = [ hatchling ];

  dependencies = [ pydantic ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  # test_rpc.py tests hang during execution
  disabledTestPaths = [ "tests/test_rpc.py" ];

  pythonImportsCheck = [ "acp" ];

  meta = {
    description = "Python SDK for building agents that communicate over stdio";
    homepage = "https://github.com/psiace/agent-client-protocol-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ethanthoma ];
  };
}


