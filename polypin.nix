# @param systems [null or [String]] If null, radFlake will generate outputs for lib.systems.flakeExposed. Otherwise, radFlake will generate outputs for these systems.
# @param nixpkgsConfig [attrset] The arguments (aside from system) that would normally be passed to `import nixpkgs`.
# @param useLib [null or String] If null, radFlake will arbitrarily select a lib to use from the following: inputs.nixpkgs.lib (if nixpkgs.inputs exists) and inputs.${n}.lib, where n is any "nixpkgs-"-prefixed attribute of inputs. Otherwise, radFlake will use inputs.${useLib}.lib
# @param f [attrset -> attrset] takes system (see @param systems) parameter, pkgs/pkgs-* parameters corresponding to certain nixpkgs inputs (see @param inputs), and inputs itself and evaluates to a regular output body
# @param inputs ; the typical inputs parameter of a flake output, but it should contain at least one set named "nixpkgs" or prefixed with "nixpkgs-" which is the output of some nixpkgs flake
# Synopsis:
#   radFlake args f
#
# Type:
#   radFlake :: {
#     inputs : AttrSet,
#     systems ? null | [ String ],
#     nixpkgsConfig ? AttrSet,
#     useLib ? null | String
#   } -> ({ system :: String, pkgs :: AttrSet, ... } -> AttrSet) -> AttrSet
#
# Inputs:
#   args
#     inputs
#       `inputs` argument as passed to `outputs`. Must contain `nixpkgs` or at least one `nixpkgs-`-prefixed attribute, and all such attributes must be the outputs of nixpkgs flakes.
#     systems
#       Target systems. Defaults to `lib.systems.flakeExposed`.
#     nixpkgsConfig
#       Configuration passed to nixpkgs (e.g., `{ allowUnfree = true; }`).
#     useLib
#       Name of the input from which to pull `lib`. Defaults to using `inputs.nixpkgs.lib` or a `inputs.nixpkgs-*` pin, chosen arbitrarily from those provided to `inputs`.
#
#   f
#     Per-system flake output function accepting `inputs`, `system`, `pkgs`, any
#     `pkgs-<pin>` for all nixpkgs pins in `inputs`.
# let
#   _assert = condition: message: if !condition then throw message else null;
# in
{
  config,
  inputs,
  lib,
  ...
}:
let
  makePkgs = np: system: import np ({ inherit system; } // config.rad-flake.nixpkgsConfig);

  altPins =
    let
      inherit (builtins)
        filter
        substring
        stringLength
        attrNames
        ;
    in
    inputs
    |> attrNames
    |> filter (n: substring 0 (stringLength "nixpkgs-") n == "nixpkgs-")
    |> map (n: substring (stringLength "nixpkgs-") (stringLength n) n);
in
{
  options.rad-flake.nixpkgsConfig = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "Extra arguments (e.g., excluding system) to pass to `import nixpkgs`.";
  };

  config.perSystem =
    { system, ... }:
    let
      pinArgs = lib.genAttrs' altPins (pin: {
        name = "pkgs-${pin}";
        value = makePkgs inputs.${"nixpkgs-${pin}"} system;
      });

      pkgsOverride = lib.optionalAttrs (!(inputs ? nixpkgs)) {
        pkgs = lib.mkDefault (makePkgs inputs.${"nixpkgs-${builtins.head altPins}"} system);
      };
    in
    assert inputs ? nixpkgs || altPins != [ ] || throw "no \"nixpkgs\" or \"nixpkgs-\"-prefixed inputs";
    {
      _module.args = pinArgs // pkgsOverride;
    };
}
