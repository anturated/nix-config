{
  lib,
  self,
  inputs,
  config,
  ...
}:

let
  inherit (lib.modules) mkIf;
  inherit (self.lib) mkFywionOption mkSecret;

  rdomain = config.networking.domain;
  cfg = config.ceirios.fywion.mailserver;
in
{
  imports = [ inputs.simple-nixos-mailserver.nixosModules.default ];

  options.ceirios.fywion.mailserver = mkFywionOption "mailserver" { domain = "mail.${rdomain}"; };

  config = mkIf cfg.enable {

    sops.secrets = {
      mailserver-desant = mkSecret {
        key = "desant";
        file = "mailserver";
      };
      mailserver-noreply = mkSecret {
        key = "noreply";
        file = "mailserver";
      };
      mailserver-spam = mkSecret {
        key = "spam";
        file = "mailserver";
      };
    };

    mailserver = {
      enable = true;
      openFirewall = true;

      stateVersion = 4;

      storage = {
        directoryLayout = "fs";
        owner = "vmail";
        group = "vmail";
        path = "/srv/storage/mail/vmail";
      };

      sieveDirectory = "/srv/storage/mail/sieve";

      # Enable STARTTLS
      enableImap = true;
      enableImapSsl = true;

      # eww
      enablePop3 = false;
      enablePop3Ssl = false;

      enableSubmission = false;
      enableSubmissionSsl = true;

      # Enable ManageSieve so that we don't need to change the config to update sieves
      enableManageSieve = true;

      # DKIM Settings
      dkim = {
        defaults.keyLength = 4096;
        keyDirectory = "/srv/storage/mail/dkim";
      };

      hierarchySeparator = "/";
      localDnsResolver = false;
      fqdn = cfg.domain;
      x509.useACMEHost = cfg.domain;
      domains = [ rdomain ];

      # Set all no-reply addresses
      rejectRecipients = [ "noreply@${rdomain}" ];

      accounts = {
        "desant@${rdomain}" = {
          hashedPasswordFile = config.sops.secrets.mailserver-desant.path;
          aliases = [
            "anturated@${rdomain}"
            "me@${rdomain}"
            "admin@${rdomain}"
            "root@${rdomain}"
            "postmaster@${rdomain}"
          ];
        };

        "noreply@${rdomain}" = {
          aliases = [ "noreply" ];
          hashedPasswordFile = config.sops.secrets.mailserver-noreply.path;
        };

        "spam@${rdomain}" = {
          aliases = [
            "shush@${rdomain}"
            "stfu@${rdomain}"
            "bot@${rdomain}"
          ];
          hashedPasswordFile = config.sops.secrets.mailserver-spam.path;
        };
      };

      mailboxes = {
        Archive = {
          auto = "subscribe";
          special_use = "\\Archive";
        };
        Drafts = {
          auto = "subscribe";
          special_use = "\\Drafts";
        };
        Sent = {
          auto = "subscribe";
          special_use = "\\Sent";
        };
        Junk = {
          auto = "subscribe";
          special_use = "\\Junk";
        };
        Trash = {
          auto = "subscribe";
          special_use = "\\Trash";
        };
      };

      fullTextSearch = {
        enable = true;
        # index new email as they arrive
        autoIndex = true;
        fallback = false;
      };
    };

    services = {
      postfix = {
        dnsBlacklists = [
          "all.s5h.net"
          "b.barracudacentral.org"
          "bl.spamcop.net"
          "blacklist.woody.ch"
        ];

        dnsBlacklistOverrides = ''
          ${rdomain} OK
          ${config.mailserver.fqdn} OK
          127.0.0.0/8 OK
          10.0.0.0/8 OK
          192.168.0.0/16 OK
        '';

        settings.main.smtp_helo_name = config.mailserver.fqdn;
      };

      nginx.virtualHosts = {
        "${cfg.domain}" = {
          forceSSL = true;
          enableACME = true;
        };
      };
    };

    security.acme.certs.${cfg.domain} = {
      reloadServices = [
        "postfix.service"
        "dovecot.service"
      ];
    };
  };
}
