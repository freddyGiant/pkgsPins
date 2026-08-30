# pkgsPins

Flake-parts module providing patterned `pkgs` derivations for each pinned `nixpkgs`

By default, for each `nixpkgs-*` input, pkgsPins supplies a corresponding `pkgs-*`.

<!-- appropriately suffixed -->
<!-- -prefixed input. -->
<!-- TODO: Document options -->

## Usage

Add this flake, flake-parts, and any nixpkgs pins to inputs and import the provided flake module.

```nix
# nixpkgs pins
inputs.nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
inputs.nixpkgs-0343e34.url = "nixpkgs/0343e3415784b2cd9c68924294794f7dbee12ab3";

inputs.flake-parts.url = "github:hercules-ci/flake-parts";
inputs.pkgsPins = "github:freddyGiant/pkgsPins"; # pkgsPins

outputs = inputs:
inputs.flake-parts.lib.mkFlake { inherit inputs; } (
  { inputs, ... }:
  {
    imports = [
      inputs.pkgsPins.flakeModules.modules # import the provided flake module
      # ...
    ];
    # ...
  }
);
```

pkgsPins will set `config.flake.pkgsPins` as an output on *your* flake. You can thus access pins via `inputs.self.pkgsPins.${system}`.

Import the provided module to inject the pinned pkgs into flake-parts perSystem module arguments.

```nix
imports = [
inputs.pkgsPins
...
];
```
