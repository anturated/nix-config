{ pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge
        Experimental = true;
        # Faster connect, more power drain
        FastConnectable = true;
        DisableAbsoluteVolume = true;
      };
      Policy = {
        # Enable all controllers when they are found.
        AutoEnable = true;
      };
    };
  };

  # bluetooth fix (i honestly have no idea why it refuses to work)
  systemd.services.unblock-bluetooth = {
    description = "Unblock Bluetooth on startup";
    wantedBy = [ "multi-user.target" ];
    after = [ "bluetooth.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      RemainAfterExit = true;
    };
  };
}
