{ ... }:

{
  _class = "nixos";

  imports = [
    ../base
    ./boot
    ./environment
    ./fywion
    ./hardware
    ./headless.nix
    ./kernel
    ./networking
    ./security
    ./services
    ./secrets.nix
    ./software
    ./system
    ./users

    ./extras.nix
  ];
}
