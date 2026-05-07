{ lib, config, ... }:

let
  inherit (lib.lists) elem;
  inherit (lib.modules) mkIf;
in
{
  # allow me to ssh into me (hobby)
  config = mkIf (elem "anturated" (builtins.attrNames config.ceirios.system.users)) {
    users.users.anturated = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOJoauZQLAdUyxVmB+oxNQK+LSQ1Y3/L///GjC+oQlG"
      ];
    };
  };
}
