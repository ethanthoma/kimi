{
  description = "Development environment with kimi-cli";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs@{ self, ... }:
    {
      overlays.default = final: prev: {
        kimi-cli = final.python3.pkgs.callPackage ./kimi-cli.nix {
          kosong = final.python3.pkgs.kosong or (final.python3.pkgs.callPackage ./kosong.nix { });
          streamingjson =
            final.python3.pkgs.streamingjson or (final.python3.pkgs.callPackage ./streamingjson.nix { });
          ripgrepy = final.python3.pkgs.ripgrepy or (final.python3.pkgs.callPackage ./ripgrepy.nix { });
          agent-client-protocol =
            final.python3.pkgs.agent-client-protocol
              or (final.python3.pkgs.callPackage ./agent-client-protocol.nix { });
          fastmcp =
            final.python3.pkgs.fastmcp or (final.python3.pkgs.callPackage ./fastmcp.nix {
              uv-dynamic-versioning =
                final.python3.pkgs.uv-dynamic-versioning
                  or (final.python3.pkgs.callPackage ./uv-dynamic-versioning.nix { });
            });
        };

        pythonPackagesExtensions = prev.pythonPackagesExtensions or [ ] ++ [
          (python-final: python-prev: {
            openai = python-prev.openai.overridePythonAttrs (oldAttrs: rec {
              version = "2.6.1";
              src = final.fetchPypi {
                pname = "openai";
                inherit version;
                hash = "sha256-J65wTRkGFfygwPwreWo4+LWHlkWjpSycRTsj+XFBu0k=";
              };
              doCheck = false;
              dontCheckRuntimeDeps = true;
            });

            typer = python-prev.typer.overridePythonAttrs (oldAttrs: rec {
              version = "0.20.0";
              src = final.fetchPypi {
                pname = "typer";
                inherit version;
                hash = "sha256-Gq9klAMXk+SHb7C6z6apErVRz0PB5jyADfixqGZyDDc=";
              };
              doCheck = false;
            });

            mcp = python-prev.mcp.overridePythonAttrs (oldAttrs: {
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

            kosong = python-final.callPackage ./kosong.nix { };
            streamingjson = python-final.callPackage ./streamingjson.nix { };
            ripgrepy = python-final.callPackage ./ripgrepy.nix { };
            agent-client-protocol = python-final.callPackage ./agent-client-protocol.nix { };
            uv-dynamic-versioning = python-final.callPackage ./uv-dynamic-versioning.nix { };
            fastmcp = python-final.callPackage ./fastmcp.nix {
              uv-dynamic-versioning = python-final.uv-dynamic-versioning;
            };
          })
        ];
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        python3Exact = import ./python-overrides.nix { inherit pkgs; };

        kosong = python3Exact.pkgs.callPackage ./kosong.nix { };
        streamingjson = python3Exact.pkgs.callPackage ./streamingjson.nix { };
        ripgrepy = python3Exact.pkgs.callPackage ./ripgrepy.nix { };
        agent-client-protocol = python3Exact.pkgs.callPackage ./agent-client-protocol.nix { };
        uv-dynamic-versioning = python3Exact.pkgs.callPackage ./uv-dynamic-versioning.nix { };
        fastmcp = python3Exact.pkgs.callPackage ./fastmcp.nix { inherit uv-dynamic-versioning; };

        kimi-cli = python3Exact.pkgs.callPackage ./kimi-cli.nix {
          inherit
            kosong
            streamingjson
            ripgrepy
            agent-client-protocol
            fastmcp
            ;
        };

      in
      {
        packages = {
          kimi-cli = kimi-cli;
          default = kimi-cli;

          inherit
            kosong
            streamingjson
            ripgrepy
            agent-client-protocol
            fastmcp
            uv-dynamic-versioning
            ;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            python3Exact
            kimi-cli
            pkgs.claude-code
          ];

          shellHook = ''
            echo "Development environment with kimi-cli loaded"
          '';
        };
      }
    );
}
