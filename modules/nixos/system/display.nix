{ pkgs, ... }:

{
  config = {
    # no idea
    services.xserver.enable = false;

    # hyprland
    programs.hyprland.enable = true;

    # enable wayland support on electron and other stuff
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # this is supposed to fix light mode
    programs.dconf.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      config.common.default = "*";
    };
  };
}
