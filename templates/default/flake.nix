{
  inputs.nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.pkgsPins.url = "github:freddyGiant/pkgsPins";

  outputs = inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs; } ({
    inputs,
    ...
  }:
  {
    imports = [ inputs.pkgsPins.flakeModules.default ];

    systems = inputs.nixpkgs.lib.systems.flakeExposed;
    perSystem = { pkgs, ... }: {
      formatter = pkgs.nixfmt-tree;
    };
  });
}
