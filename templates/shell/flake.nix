{
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.pkgs-pins.url = "github:freddyGiant/pkgs-pins";

  outputs = inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs; } ({
    inputs,
    ...
  }:
  {
    imports = [ inputs.pkgs-pins.flakeModules.default ];

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
