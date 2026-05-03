{ config, ... }:

let
  isLaptop = config.ceirios.profiles.laptop;
in
{
  services.tuned = {
    enabled = isLaptop;
    ppdSettings.main.battery_detection = true;
  };
}
