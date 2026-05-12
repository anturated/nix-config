{
  lib,
  config,
  self,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (self.lib) mkSecret mkFywionOption;

  cfg = config.ceirios.fywion.obsidian-livesync;
in
{
  options.ceirios.fywion.obsidian-livesync = mkFywionOption "CouchDB + nginx" {
    inherit (config.networking) domain;
    port = 5984;
  };

  config = mkIf cfg.enable {
    services = {
      couchdb = {
        enable = true;
        extraConfigFiles = [
          config.sops.secrets.couchdbExtraConfig.path
        ];
        # based upon https://github.com/vrtmrz/obsidian-livesync/blob/main/docs/setup_own_server.md#traefik
        extraConfig = {
          chttpd_auth = {
            require_valid_user = true;
          };
          httpd = {
            WWW-Authenticate = "Basic realm=\"couchdb\"";
            enable_cors = true;
          };
          chttpd = {
            max_http_request_size = 4294967296;
          };
          couchdb = {
            max_document_size = 50000000;
          };
          cors = {
            credentials = true;
            origins = "app://obsidian.md,capacitor://localhost,http://localhost";
          };
        };
      };

      nginx.virtualHosts."obsidian.${cfg.domain}" = {
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          extraConfig = "proxy_buffering off;";
        };
      };
    };

    # extraconfig is just
    # [admins]
    # username = password
    sops.secrets.couchdbExtraConfig = mkSecret {
      key = "extraConfig";
      file = "obsidian-livesync";
      owner = "couchdb";
      group = "couchdb";
    };
  };
}
