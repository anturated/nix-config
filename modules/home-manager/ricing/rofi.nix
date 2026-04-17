{ ... }:

{
  programs.rofi = {
    enable = true;
    theme = ./rofi/drun.rasi;
  };

  xdg.configFile = {
    "rofi/shared.rasi".source = ./rofi/shared.rasi;
    # "rofi/drun.rasi".source = ./rofi/drun.rasi;
    "rofi/wallpaper.rasi".source = ./rofi/wallpaper.rasi;
  };
}
