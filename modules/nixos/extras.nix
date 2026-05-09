{ inputs, ... }:

{
  imports = [
    inputs.fywion.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];
}
