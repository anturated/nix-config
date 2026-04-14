{
  config,
  lib,
  pkgs,
  ...
}:

let
  quick = config.machine.boot.quick;
  usePlymouth = config.machine.boot.plymouth;
in
{
  boot = {
    # time to choose derivation
    # (0 still lets you press ESC)
    loader.timeout = 0;

    # something related to boot logs (probably)
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "rd.systemd.show_status=false"
      "ntsync"
    ];

    # i have ONE ntfs partition and it needs to go
    supportedFilesystems = [ "ntfs" ];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # optional plymouth
    plymouth = lib.mkIf usePlymouth {
      enable = true;
      theme = "circle_hud";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "circle_hud" ];
        })
      ];
    };

    # compress initramfs (no idea how it helps but ok)
    initrd.compressor = lib.mkIf quick "zstd";
    # don't wait for online
    systemd.services.NetworkManager-wait-online.enable = lib.mkIf quick false;
  };
}
