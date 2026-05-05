{ lib, ... }:

{
  # prevent using ~/.config/nixpkgs/config.nix
  environment.variables.NIXPKGS_CONFIG = lib.mkForce "";
}
