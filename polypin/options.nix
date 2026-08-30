{ config, inputs, lib, options, ... }: {
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

    systems = lib.mkOption {
      type = options.systems.type;
      default = config.systems;
      description = "Systems for which to create pins";
    };

    nixpkgsConfig = lib.mkOption {
      # type = inputs.nixpkgs.options.config.type;
      type = 
      default = { };
      description = "Extra arguments (e.g., excluding system) to pass to `import nixpkgs`";
    };
  };
}
