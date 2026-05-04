{
  config,
  lib,
  pkgs,
  ...
}:

let
  quick = config.machine.boot.quick;
  user = config.ceirios.system.mainUser;
in
{
  options.ceirios.system.login = {
    autoLogin = lib.mkEnableOption "Enable auto login";
  };

  config.services.greetd = {
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
