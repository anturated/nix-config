{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.ceirios.hardware.bluetooth = {
    enable = mkEnableOption "bluetooth support";
  };

  config = mkIf config.ceirios.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;

      # might fix autostart
      disabledPlugins = [ "sap" ];

      settings = {
        General = {
          # Shows battery charge
          Experimental = true;
          # Faster connect, more power drain
          FastConnectable = true;
          DisableAbsoluteVolume = true;
          # repair stuff
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
        };

        # Enable all controllers when they are found.
        Policy.AutoEnable = true;
      };
    };
  };
}
