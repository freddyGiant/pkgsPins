{
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-parts.url = "hercules-ci/flake-parts";
  inputs.rad-flake.url = "freddyGiant/rad-flake";

  outputs =
    { nixpkgs, flake-parts, rad-flake }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ rad-flake.flakeModules.default ];

      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = { pkgs, ... }: { };
    };
}
