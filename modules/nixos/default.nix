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
    ./software
    ./system
  ];
}
