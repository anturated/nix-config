{ config, ... }:

{
  programs.cava = {
    enable = config.ceirios.profiles.graphical;
    settings = {
      color = {
        theme = "ivy";
      };
    };
  };
}
