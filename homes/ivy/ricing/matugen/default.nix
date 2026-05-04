{ ... }:

{
  xdg.configFile = {
    "matugen/config.toml".source = ./config.toml;
    "matugen/templates".source = ./templates;
  };
}
