{
  description = "flake-parts module that deals with extra nixpkgs pins";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      {
        self,
        lib,
        options,
        ...
      }:
      {
        imports = [
          inputs.flake-parts.flakeModules.modules
          ./pkgsPins
        ];

        config.flake = {
          flakeModules.default = ./pkgsPins;
          flakeModule = self.flakeModules.default;

          templates.default.path = ./templates/default;
          templates.default.description = ''
            Barebones flake-parts boilerplate, with the pkgsPins module
          '';

          templates.shell.path = ./templates/shell;
          templates.shell.description = ''
            Hop straight into a basic devShell.
          '';
        };

        config.systems = inputs.nixpkgs.lib.systems.flakeExposed;
        config.perSystem = { pkgs, ... }: { formatter = pkgs.nixfmt-tree; };
      }
    );
}
