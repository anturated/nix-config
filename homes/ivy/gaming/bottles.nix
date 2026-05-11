{
  config,
  lib,
  inputs',
  ...
}:

{
  config = lib.mkIf config.ceirios.profiles.gaming {
    ceirios.packages = {
      # using stable here because openldap won't pass tests
      inherit (inputs'.nixpkgs-stable.legacyPackages) bottles;
    };

    # audio fix
    home.file.".alsoftrc".text = "drivers=pulse";
  };
}
