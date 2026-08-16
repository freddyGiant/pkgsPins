{
  description = "flake-parts module that deals with extra nixpkgs pins";

  outputs = { self }: {
    flakeModules.default = ./rad-flake.nix;
    flakeModule = self.flakeModules.default;

    templates.default.path = ./templates/default;
    templates.default.description = ''
      Barebones flake-parts boilerplate, with the rad-flake module.
    '';

    # templates.shell.path = ./templates/
  };
}
