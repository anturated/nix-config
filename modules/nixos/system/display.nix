{ pkgs, ... }:

{
  config = {
    # no idea
    services.xserver.enable = false;

    # hyprland
    programs.hyprland.enable = true;

    # enable wayland support on electron and other stuff
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # TODO: doesnt work probably
    qt.platformTheme = "qt5ct";
  };
}
