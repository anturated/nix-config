{
  lib,
  self,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (self.lib) mkFywionOption;

  cfg = config.ceirios.fywion.anubis;
in
{
  options.ceirios.fywion.anubis = mkFywionOption "anubis" { };

  config = mkIf cfg.enable {
    # allow using ports
    users.users.nginx.extraGroups = [
      config.users.groups.anubis.name
    ];
  };
}
