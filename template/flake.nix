{
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-parts.url = "hercules-ci/flake-parts";
  inputs.rad-flake.url = "freddyGiant/rad-flake";

  outputs =
    { flake-parts, rad-flake }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ rad-flake.flakeModules.default ];

      perSystem = { pkgs, ... }: { };
    };
}
