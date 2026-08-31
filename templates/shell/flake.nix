{
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.pkgsPins.url = "github:freddyGiant/rad-flake";

  outputs = inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs; } ({
    inputs,
    ...
  }:
  {
    imports = [ inputs.pkgsPins.flakeModules.default ];

    systems = inputs.nixpkgs.lib.systems.flakeExposed;
    perSystem = { pkgs, ... }: {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [

        ];

        shellHook = /* bash */ ''
          #
        '';
      };

      formatter = pkgs.nixfmt-tree;
    };
  });
}
