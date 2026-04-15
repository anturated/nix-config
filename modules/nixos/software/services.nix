{ pkgs, ... }:

{
  # for widgets likely
  services.upower.enable = true;
  services.udisks2.enable = true;

  # TODO: make conditional
  # services.power-profiles-daemon.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      CPU_BOOST_ON_AC = 0;
      CPU_BOOST_ON_BAT = 0;
    };
  };

  # need this for gpg signing
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  # keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # file structure normalifyer
  programs.nix-ld.enable = true;

  # mouse settings
  services.ratbagd.enable = true;
}
