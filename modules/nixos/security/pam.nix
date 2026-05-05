{ lib, config, ... }:

let
  inherit (lib) genAttrs mkIf mkMerge;

  services = [
    "login"
    "greetd"
    "tuigreet"
  ];

  mkService = {
    enableGnomeKeyring = true;
    gnupg = {
      enable = true;
      noAutostart = true;
      storeOnly = true;
    };
  };
in
{
  security.pam = mkMerge [
    {
      # allow screen lockers to also unlock the screen
      # (e.g. swaylock, gtklock)
      # NOTE: whar
      services = {
        swaylock.text = "auth include login";
        gtklock.text = "auth include login";
      };
    }

    (mkIf config.ceirios.profiles.graphical {
      services = genAttrs services (_: mkService);
    })
  ];
}
