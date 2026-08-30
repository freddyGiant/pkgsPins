# pkgs-pins

Flake-parts module providing patterned `pkgs` derivations for each pinned `nixpkgs`

By default, pkgs-pins supplies an appropriately suffixed `pkgs-*` for each `nixpkgs-`-prefixed input.
<!-- TODO: Document options -->

## Usage

Add this flake as an input.
```nix
inputs.pkgs-pins.url = "github:freddyGiant/pkgs-pins";
```

pkgs-pins will set `config.flake.pkgs-pins.${system}` as an output on *your* flake. You can thus access it via `inputs.self.pkgs-pins.${system}`.
This will provide  under `???.${system}.pins`.

Import the provided module to inject the pinned pkgs into flake-parts perSystem module arguments.
```nix
imports = [
inputs.pkgs-pins
...
];
```
