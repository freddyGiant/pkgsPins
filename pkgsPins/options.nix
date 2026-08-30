{
  config,
  inputs,
  lib,
  options,
  ...
}:
{
  options.pkgsPins = {
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

    systems = lib.mkOption {
      type = options.systems.type;
      default = config.systems;
      description = "Systems for which to create pins";
    };

    nixpkgsConfig = lib.mkOption {
      type = lib.types.deferredModule;
      default = { };
      description = "Extra arguments (e.g., allowUnfree, overlays, but probably not system) to pass to `import nixpkgs`";
    };
  };
}
