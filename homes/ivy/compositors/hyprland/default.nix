{
  pkgs,
  config,
  lib,
  ...
}:

{
  # https://wiki.hypr.land/Configuring/Configuring-Hyprland/
  imports = [
    ./autostart.nix
    ./environment.nix
    ./permissions.nix
    ./look_and_feel.nix
    ./input.nix
    ./keybinds.nix
    ./monitors.nix
    ./windows_and_workspaces.nix
  ];

  config = lib.mkIf config.ceirios.profiles.graphical {

    wayland.windowManager.hyprland = {
      enable = true;
      # TODO: check out what lua is
      configType = "hyprlang";
    };

    ceirios.packages = {
      inherit (pkgs) hyprshot hyprsunset;
    };

    # xdg-desktop-portal-hyprland config
    # https://wiki.hypr.land/Hypr-Ecosystem/xdg-desktop-portal-hyprland/
    xdg.configFile."hypr/xdph.conf".text = ''
      screencopy {
        max_fps = 60
        allow_token_by_default = true
      }
    '';
  };
}
