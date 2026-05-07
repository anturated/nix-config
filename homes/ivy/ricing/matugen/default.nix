{
  pkgs,
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.ceirios.profiles.graphical {
    ceirios.packages = {
      inherit (pkgs) matugen;
    };

    xdg.configFile = {
      "matugen/config.toml".source = ./config.toml;
      "matugen/templates".source = ./templates;
    };
  };
}
