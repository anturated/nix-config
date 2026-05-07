{ ... }:

{
  _class = "nixos";

  imports = [
    ../base
    ./boot
    ./environment
    ./hardware
    ./headless.nix
    ./kernel
    ./networking
    ./scripts
    ./security
    ./secrets.nix
    ./software
    ./system
    ./users

    ./extras.nix
  ];
}
