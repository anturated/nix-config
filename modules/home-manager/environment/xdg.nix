{ lib, ... }:

{
  xdg = {
    # disable in home, let nixos manage it
    portal.enable = lib.mkForce false;
  };
}
