{
  config,
  inputs,
  lib,
  ...
}:
let
  makePkgs = pkgsInput: system:
    import pkgsInput ({ inherit system; } // config.pkgsPins.nixpkgsConfig);

  pinNames =
  let
    inherit (builtins)
      filter
      substring
      stringLength
      attrNames
      ;

    prefixLength = stringLength config.pkgsPins.inputPrefix;
    withoutPrefix = s: substring prefixLength (stringLength s - prefixLength);
  in
    inputs
    |> attrNames
    |> filter (lib.strings.hasPrefix config.pkgsPins.inputPrefix)
    |> map withoutPrefix;

  mkPins = system:
  let
    pkgsPins = lib.genAttrs' pinNames (pin: {
      name = "pkgs-${pin}";
      value = makePkgs inputs.${"nixpkgs-${pin}"} system;
    });

    # flake-utils handles nixpkgs -> pkgs, but if no plain nixpkgs input is present, we need to provide one of the pins
    arbitraryPkgs = lib.optionalAttrs (!(inputs ? nixpkgs) && pinNames != [ ]) {
      pkgs = lib.mkDefault (
        makePkgs inputs.${"nixpkgs-${builtins.head pinNames}"} system
      );
    };
  in
    pkgsPins // arbitraryPkgs;
in
{
  config.flake.pkgsPins.pins = lib.genAttrs config.pkgsPins.systems mkPins;
  config.perSystem = { system, ...}: { _module.args = mkPins system; };
}
