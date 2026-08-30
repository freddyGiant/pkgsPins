# Polypin

Flake-parts module providing patterned `pkgs` derivations for each pinned `nixpkgs`

By default, Polypin supplies an appropriately suffixed `pkgs-*` for each `nixpkgs-`-prefixed input.
<!-- TODO: Document options -->

## Usage

Add this flake as an input.
```nix
inputs.polypin.url = "github:freddyGiant/polypin";
```

Polypin will set `config.flake.polypin.${system}` as an output on *your* flake. You can thus access it via `inputs.self.polypin.${system}`.
This will provide  under `???.${system}.pins`.

Import the provided module to inject the pinned pkgs into flake-parts perSystem module arguments.
```nix
imports = [
inputs.polypin
...
];
```
