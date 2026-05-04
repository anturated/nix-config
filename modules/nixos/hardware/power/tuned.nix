{ config, ... }:

let
  isLaptop = config.ceirios.profiles.laptop;
in
{
  services.tuned = {
    enable = isLaptop;
    ppdSettings.main.battery_detection = true;
  };
}
