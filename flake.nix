{
  description = "Development environment with kimi-cli";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs@{ self, ... }:

    inputs.flake-utils.lib.eachDefaultSystem (
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
