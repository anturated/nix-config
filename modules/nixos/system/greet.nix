{
  config,
  lib,
  pkgs,
  user,
  ...
}:

let
  quick = config.machine.boot.quick;
in
{
  # quick(?) autologin
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
        user = "${user}";
      };
      initial_session = lib.mkIf quick {
        command = "start-hyprland";
        user = "${user}";
      };
    };
  };
}
