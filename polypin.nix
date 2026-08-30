{
  config,
  inputs,
  lib,
  options,
  ...
}:
let
  makePkgs =
    pkgsInput: system: import pkgsInput ({ inherit system; } // config.rad-flake.nixpkgsConfig);

  pinNames =
    let
      inherit (builtins)
        filter
        substring
        stringLength
        attrNames
        ;

      prefixLength = stringLength config.polypin.inputPrefix;
      withoutPrefix = s: substring prefixLength (stringLength s - prefixLength);
    in
    inputs
    |> attrNames
    |> filter (lib.strings.hasPrefix config.polypin.inputPrefix)
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
  options.polypin = {
    inputPrefix = lib.mkOption {
      type = lib.types.str;
      default = "nixpkgs-";
      description = "To find and strip from input names";
    };

    outputPrefix = lib.mkOption {
      type = lib.types.str;
      default = "pkgs-";
      description = "if you change this you're a weirdo";
    };

    nixpkgsConfig = lib.mkOption {
      type = options.nixpkgs.config.type;
      default = { };
      description = "Extra arguments (e.g., excluding system) to pass to `import nixpkgs`.";
    };
  };

  # this will be the user's config.systems when they import this module
  config.flake.polypin.pins = lib.genAttrs config.systems mkPins;
  config.perSystem = { system, ...}: { _module.args = mkPins system; };
}
