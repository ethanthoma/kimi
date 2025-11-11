# Override Python packages to match exact kimi-cli requirements
# Following nixpkgs Python best practices from:
# https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md
{ pkgs }:

pkgs.python313.override {
  packageOverrides = pythonself: pythonsuper: {
    # aiofiles 25.1.0 - required by kimi-cli
    aiofiles = pythonsuper.aiofiles.overridePythonAttrs (oldAttrs: rec {
      version = "25.1.0";
      src = pkgs.fetchPypi {
        pname = "aiofiles";
        inherit version;
        hash = "sha256-qNco8KKd5F3FIfGPByl0KNVpkqdC8M0nAbqG5E0j1bI=";
      };
      build-system = oldAttrs.build-system or [ ] ++ [ pythonself.hatch-vcs ];
      doCheck = false;
    });

    # aiohttp 3.13.2 - required by kimi-cli
    aiohttp = pythonsuper.aiohttp.overridePythonAttrs (oldAttrs: rec {
      version = "3.13.2";
      src = pkgs.fetchPypi {
        pname = "aiohttp";
        inherit version;
        hash = "sha256-QBdqUsGGrv726zytLN0wzQbjr76I/oqyr5wLkPIo2so=";
      };
      doCheck = false;
    });

    # click 8.3.0 - required by kimi-cli
    click = pythonsuper.click.overridePythonAttrs (oldAttrs: rec {
      version = "8.3.0";
      src = pkgs.fetchPypi {
        pname = "click";
        inherit version;
        hash = "sha256-57gjIiTroW9OvkEMJc7Z94dctfMmP/yTzD6NpwXiKcQ=";
      };
    });

    # patch-ng 1.19.0 - required by kimi-cli
    patch-ng = pythonsuper.patch-ng.overridePythonAttrs (oldAttrs: rec {
      version = "1.19.0";
      src = pkgs.fetchPypi {
        pname = "patch-ng";
        inherit version;
        hash = "sha256-J0hHkvSsHBX+Lz5M7PdLuYM9M7dccVtx0Zn34efR94Y=";
      };
    });

    # pillow 12.0.0 - required by kimi-cli
    pillow = pythonsuper.pillow.overridePythonAttrs (oldAttrs: rec {
      version = "12.0.0";
      src = pkgs.fetchPypi {
        pname = "pillow";
        inherit version;
        hash = "sha256-h9T4ElyZiL++1nr0fdepU+L8ewzB54AOxtIIDUkLs1M=";
      };
      build-system = oldAttrs.build-system or [ ] ++ [ pythonself.pybind11 ];
      doCheck = false;
    });

    # rich 14.2.0 - required by kimi-cli
    rich = pythonsuper.rich.overridePythonAttrs (oldAttrs: rec {
      version = "14.2.0";
      src = pkgs.fetchPypi {
        pname = "rich";
        inherit version;
        hash = "sha256-c/9Qx8DBx3yCQweSg/Tts3bw9kQkM67LjOfm0LktH+Q=";
      };
      doCheck = false;
    });
  };
}

