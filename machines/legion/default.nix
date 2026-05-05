{ ... }:

{
  imports = [
    ./mounts.nix
  ];

  ceirios = {
    profiles = {
      laptop = true;
      workstation = true;
      graphical = true;
      gaming = true;
      coding = true;
    };

    hardware = {
      cpu = "amd";
      gpu = "nv-hybrid";

      busIds = {
        primary = "6:0:0";
        discrete = "1:0:0";
      };

      monitors = {
        eDP-1.refresh-rate = 120;
        DP-1 = { };
      };
    };

    system = {
      login.autoLogin = true;
      stateVersion = "25.05";
      flakeDir = "$HOME/Documents/projects/nix-config";
    };
  };
}
