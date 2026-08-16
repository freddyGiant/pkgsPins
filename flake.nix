{
  description = "flake-parts module that deals with extra nixpkgs pins";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs =
    {
      self,
      flake-parts,
      nixpkgs,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./rad-flake.nix ];

      flake = {
        flakeModules.default = ./rad-flake.nix;
        flakeModule = self.flakeModules.default;

        templates.default.path = ./templates/default;
        templates.default.description = ''
          Barebones flake-parts boilerplate, with the rad-flake module.
        '';

        templates.shell.path = ./templates/shell;
        templates.shell.description = ''
          Hop straight into a basic devShell.
        '';
      };

      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = { pkgs, ... }: { formatter = pkgs.nixfmt-tree; };
    };
}
