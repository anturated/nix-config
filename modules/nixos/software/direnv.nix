{ config, ... }:

{

  programs.direnv = {
    enable = config.ceirios.profiles.coding;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };
}
