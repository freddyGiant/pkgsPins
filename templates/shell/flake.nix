{
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.rad-flake.url = "github:freddyGiant/rad-flake";

  outputs =
    {
      nixpkgs,
      flake-parts,
      rad-flake,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ rad-flake.flakeModules.default ];

      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [

            ];

            shellHook = /* bash */ ''
              #
            '';
          };
        };
    };
}
