{ ... }:

{
  nix = {
    settings = {
      # Free up to 20GiB whenever there is less than 5GB left.
      # this setting is in bytes, so we multiply with 1024 by 3
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;

      # disable usage of nix channels
      channel.enable = false;

      # very dangerous bleeding edge stuff here
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # disable dirty tree warning
      warn-dirty = false;

      # let the system decide the number of max jobs
      max-jobs = "auto";

      # whether to accept nix configuration from a flake without prompting
      accept-flake-config = false;
    };

    # garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    #  auto-optimize store
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
}
