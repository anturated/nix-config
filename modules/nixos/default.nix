{ ... }:

{
  _class = "nixos";

  imports = [
    ../base
    ./boot
    ./environment
    ./hardware
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
