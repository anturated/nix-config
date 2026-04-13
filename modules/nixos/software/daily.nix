{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.vivaldi
    pkgs.telegram-desktop
    pkgs.vesktop
    pkgs.anytype
    pkgs.kdePackages.dolphin
    pkgs.libreoffice
    pkgs.olympus
    pkgs.tradingview
  ];

}
