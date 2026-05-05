{ pkgs, ... }:

{
  ceirios.packages = {
    inherit (pkgs)
      pavucontrol
      gnome-calculator
      nautilus
      eog
      piper
      vlc
      losslesscut-bin
      okteta
      gnome-disk-utility
      transmission_4-gtk
      coppwr
      anydesk
      ;
  };
  inherit (pkgs.kdePackages) kate ark;
}
