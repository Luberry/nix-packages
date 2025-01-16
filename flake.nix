{
  description = "luberry packages and modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        {
          self',
          pkgs,
          lib,
          system,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
          };

          treefmt = {
            programs.nixfmt.enable = true;
            programs.nixfmt.package = pkgs.nixfmt-rfc-style;
            programs.yamlfmt.enable = true;
            programs.mdformat.enable = true;
            settings.excludes = [
              ".editorconfig"
              ".gitignore"
              "flake.lock"
              "*.h"
              "*.json"
            ];
          };

          packages = import ./pkgs { inherit pkgs; };

          checks =
            let
              blacklistPackages = {
                "x86_64-linux" = [ ];
                "aarch64-linux" = [ ];
              };
              packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") (
                lib.filterAttrs (n: _v: !(builtins.elem n blacklistPackages.${system})) self'.packages
              );
            in
            packages;
        };

      flake = {
        overlays = {
          default = final: prev: import ./pkgs { pkgs = prev; };
        };

      };

    };
}
