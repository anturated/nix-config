{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.ceirios.hardware.bluetooth = {
    enable = mkEnableOption "bluetooth support" // {
      default = true;
    };
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

    # bluetooth fix (i honestly have no idea why it refuses to work)
    # TODO: remove if sap fixes it
    # systemd.services.unblock-bluetooth = {
    #   description = "Unblock Bluetooth on startup";
    #   wantedBy = [ "multi-user.target" ];
    #   after = [ "bluetooth.service" ];
    #   serviceConfig = {
    #     Type = "oneshot";
    #     ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
    #     RemainAfterExit = true;
    #   };
    # };
  };
}
