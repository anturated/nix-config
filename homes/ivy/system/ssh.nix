{ config, ... }:

{
  programs.ssh = {
    enable = config.ceirios.profiles.workstation;
    enableDefaultConfig = false;

    includes = [ ];

    matchBlocks = {
      "pinwydd" = {
        user = "anturated";
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
}
