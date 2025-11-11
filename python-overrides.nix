{ pkgs }:

pkgs.python313.override {
  packageOverrides = pythonself: pythonsuper: {
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

    aiohttp = pythonsuper.aiohttp.overridePythonAttrs (oldAttrs: rec {
      version = "3.13.2";
      src = pkgs.fetchPypi {
        pname = "aiohttp";
        inherit version;
        hash = "sha256-QBdqUsGGrv726zytLN0wzQbjr76I/oqyr5wLkPIo2so=";
      };
      doCheck = false;
    });

    click = pythonsuper.click.overridePythonAttrs (oldAttrs: rec {
      version = "8.3.0";
      src = pkgs.fetchPypi {
        pname = "click";
        inherit version;
        hash = "sha256-57gjIiTroW9OvkEMJc7Z94dctfMmP/yTzD6NpwXiKcQ=";
      };
    });

    patch-ng = pythonsuper.patch-ng.overridePythonAttrs (oldAttrs: rec {
      version = "1.19.0";
      src = pkgs.fetchPypi {
        pname = "patch-ng";
        inherit version;
        hash = "sha256-J0hHkvSsHBX+Lz5M7PdLuYM9M7dccVtx0Zn34efR94Y=";
      };
    });

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

    rich = pythonsuper.rich.overridePythonAttrs (oldAttrs: rec {
      version = "14.2.0";
      src = pkgs.fetchPypi {
        pname = "rich";
        inherit version;
        hash = "sha256-c/9Qx8DBx3yCQweSg/Tts3bw9kQkM67LjOfm0LktH+Q=";
      };
      doCheck = false;
    });

    openai = pythonsuper.openai.overridePythonAttrs (oldAttrs: rec {
      version = "2.6.1";
      src = pkgs.fetchPypi {
        pname = "openai";
        inherit version;
        hash = "sha256-J65wTRkGFfygwPwreWo4+LWHlkWjpSycRTsj+XFBu0k=";
      };
      doCheck = false;
      dontCheckRuntimeDeps = true;
    });

    typer = pythonsuper.typer.overridePythonAttrs (oldAttrs: rec {
      version = "0.20.0";
      src = pkgs.fetchPypi {
        pname = "typer";
        inherit version;
        hash = "sha256-Gq9klAMXk+SHb7C6z6apErVRz0PB5jyADfixqGZyDDc=";
      };
      doCheck = false;
    });

    mcp = pythonsuper.mcp.overridePythonAttrs (oldAttrs: {
      postPatch = (oldAttrs.postPatch or "") + ''
        sed -i 's/"uv-dynamic-versioning"/"hatchling"/g' pyproject.toml || true
        sed -i 's/dynamic = \["version"\]/dynamic = []/g' pyproject.toml || true
        sed -i '/dynamic = \[\]/d' pyproject.toml || true
        if ! grep -q '^version = ' pyproject.toml; then
          sed -i '/\[project\]/a version = "${oldAttrs.version}"' pyproject.toml || true
        fi
        sed -i '/\[tool.hatch.version\]/,/^$/d' pyproject.toml || true
      '';
      doCheck = false;
    });
  };
}
