{ config, lib, ... }:

{
  config = lib.mkIf config.ceirios.profiles.graphical {
    programs.rofi = {
      enable = true;
      theme = ./drun.rasi;
    };

    xdg.configFile = {
      "rofi/shared.rasi".source = ./shared.rasi;
      # "rofi/drun.rasi".source = ./rofi/drun.rasi;
      "rofi/wallpaper.rasi".source = ./wallpaper.rasi;
    };
  };
}
