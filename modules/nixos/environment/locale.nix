{ config, lib, ... }:

let
  inherit (lib) mkOption types;
  inherit (types) str;
in
{
  options.ceirios.system = {
    timeZone = mkOption {
      type = str;
      default = "Europe/Warsaw";
      description = "time.timeZone shortcut";
    };

    locale = mkOption {
      type = str;
      default = "en_US.UTF-8";
      description = "i18n.defaultLocale shortcut";
    };
  };

  time.timeZone = "${config.ceirios.system.timeZone}";
  i18n.defaultLocale = "${config.ceirios.system.locale}";
}
