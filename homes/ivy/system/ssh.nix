{ config, ... }:

{
  programs.ssh = {
    enable = config.ceirios.profiles.workstation;
    enableDefaultConfig = false;

    includes = [ ];

    matchBlocks = {
      "pinwydd" = {
        user = "desant";
        hostname = "82.38.2.58";
      };

      "fawrion" = {
        user = "desant";
        hostname = "185.233.46.184";
      };

      "brethyn" = {
        user = "wizards";
        hostname = "185.233.36.209";
      };

      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = true;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = true;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };

  home.file.".ssh/id_ed25519.pub".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOJoauZQLAdUyxVmB+oxNQK+LSQ1Y3/L///GjC+oQlG
  '';

  sops.secrets = {
  };
}
