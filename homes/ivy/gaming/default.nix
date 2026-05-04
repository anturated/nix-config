{ lib, config, ... }:

{
  imports = lib.optionals config.ceirios.profiles.gaming [
    ./gamemode.nix
    ./mangohud.nix
    ./prism.nix
    ./steam.nix
  ];
}
