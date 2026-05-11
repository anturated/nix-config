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
    };

    hardware = {
      cpu = "amd";
      gpu = "nv-hybrid";
      bluetooth.enable = true;

      busIds = {
        primary = "6:0:0";
        discrete = "1:0:0";
      };

      monitors = {
        # why 2 :cry: it was 1 before
        eDP-2.refresh-rate = 120;
        DP-1 = { };
      };
    };

    system = {
      stateVersion = "25.05";
      flakeDir = "$HOME/dev/dotfiles";
    };
  };
}
