{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) concatStringsSep;
  inherit (config.ceirios.system.login) autoLogin;
  inherit (config.ceirios.system) mainUser;

  enable = config.ceirios.profiles.graphical;
  sessionData = config.services.displayManager.sessionData.desktops;
in
{
  options.ceirios.system.login = {
    autoLogin = lib.mkEnableOption "Enable auto login";
  };

  config.services.greetd = {
    inherit enable;
    restart = true;
    useTextGreeter = true;

    settings = {
      default_session = {
        user = "greeter";
        command = concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time" # display date & time
          "--remember" # remember last username
          "--remember-user-session" # remember user's last session
          "--asterisks" # password turns into ****
          "--sessions '${
            concatStringsSep ":" [
              "${sessionData}/share/xsessions"
              "${sessionData}/share/wayland-sessions"
            ]
          }'"
        ];
      };

      initial_session = lib.mkIf autoLogin {
        command = "start-hyprland";
        user = "${mainUser}";
      };

    };
  };
}
