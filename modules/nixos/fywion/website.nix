{
  lib,
  config,
  self,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (self.lib) mkFywionOption;

  cfg = config.ceirios.fywion.anturated-website;
in
{
  options.ceirios.fywion.anturated-website = mkFywionOption "anturated-website" {
    inherit (config.networking) domain;
    port = 3000;
  };

  config = mkIf cfg.enable {
    fywion.anturated-website.enable = true;

    # gotta configure nginx
    # because fywion has no idea what the setup is
    services.nginx.virtualHosts.${cfg.domain} = {
      serverAliases = [ "www.${cfg.domain}" ];
      enableACME = true;
      locations."/" = {
        proxyPass = "http://${cfg.host}:${toString cfg.port}";
      };
    };
  };
}
