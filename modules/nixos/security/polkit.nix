{ config, ... }:

{
  security = {
    polkit.enable = true;

    # this should only be installed on graphical systems
    soteria.enable = config.ceirios.profiles.graphical;
  };
}
