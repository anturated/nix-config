{
  lib,
  pkgs,
  self,
  config,
  ...
}:

let
  inherit (lib.attrsets) concatMapAttrs;
  inherit (self.lib) mkPubs;
in
{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;

    allowSFTP = true;

    settings = {
      # Don't allow root login
      PermitRootLogin = "no";

      # only allow key based logins and not password
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AuthenticationMethods = "publickey";
      PubkeyAuthentication = "yes";
      ChallengeResponseAuthentication = "no";
      UsePAM = false;
      UseDns = false;
      X11Forwarding = false;

      # Use key exchange algorithms recommended by `nixpkgs#ssh-audit`
      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "sntrup761x25519-sha512@openssh.com"
        "diffie-hellman-group-exchange-sha256"
        "mlkem768x25519-sha256"
        "sntrup761x25519-sha512"
      ];

      # Use Macs recommended by `nixpkgs#ssh-audit`
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];

      # kick out inactive sessions
      ClientAliveCountMax = 5;
      ClientAliveInterval = 60;

      Banner = toString (
        pkgs.writeText "ssh_banner" ''
          • ────   Ceirios ──── •
             : ${config.system.name}
             : ${config.system.configurationRevision}
             : ${config.system.nixos.release}
          • ──────────────────── •
        ''
      );
    };

    openFirewall = true;
    # the port(s) openssh daemon should listen on
    ports = [ 22 ];

    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    # find these with `ssh-keyscan <hostname>`
    knownHosts = concatMapAttrs mkPubs {
      "github.com" = [
        {
          type = "rsa";
          key = "AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
        }
        {
          type = "ed25519";
          key = "AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        }
      ];

      "git.anturated.dev" = [
        {
          type = "rsa";
          key = "AAAAB3NzaC1yc2EAAAADAQABAAACAQDgasL74TZGpTTbUyoSwBb1MYm8+vR78vcFJV+yX8ZVDdZGJcF4v13e0k6rLfR19iH/AVLr+hVIlzVkYJ4CcNszaGjUu9TaVzeYHXhQKYDITktJM56Sm7bN0Ra4Y44BDQgilBYUphG6FuvJSuKMbTBYdpiIjupd9b/5hfDhHqUHac07OWVBZrS9q/kyNrQSMn7syXOpuLl/CvIvYdZPjiHzUODabInLmRdfIolhsFkfrTfFC+DLjRDID7WdTMpFtmY4dmqDI1V7osS0jM/6wtZb4tkMNBUeQLclEUudWt1swC4gRV2eyq2byw/QzAmC6nR8diGDBrw0rGQO2JnRTCvVPRMHbCFKYC59+nKB8TFqPcw/5/Ux2VI5S1cURWKkExRPwHwQrf9oQlihsKGeB47crf3FpPJwLgrKjCCF6TDEBxcb7DucycviTmVIzYy+P02HLIEI4TKZY7GMG3SWEYikZLwPXGPiVQgnrD0qu7sF6XOT9WbHo1fIhZCNlQsYjuqjWb+PvgFU7P8/GleUEdRtRdVyA4UdnWVmtjhWHxXwYJvMlvybwlikiGSCV/fpIp3mkOYVrvFUYGUGvVZQOeS4hq+WrrdDLTjYoWCheWJJyt/hxvzYl9trEWPU+j1Oo9Pr8rLVGUJhs6f51llEPuMRp0/sokE00nRM96wVJOCv7Q==";
        }
        {
          type = "ed25519";
          key = "AAAAC3NzaC1lZDI1NTE5AAAAINNsMAoi3+7N7B9uqG8sU/mGvnLBHXMhC1jzpgBO0n02";
        }
      ];
    };
  };
}
