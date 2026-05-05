{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  xdg.portal = {
    enable = mkDefault config.ceirios.profiles.graphical;

    xdgOpenUsePortal = true;

    config = {
      common = {
        default = [ "gtk" ];

        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };

    wlr = {
      enable = mkDefault config.ceirios.profiles.graphical;
      settings = {
        screencast = {
          max_fps = 60;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
  };
}
