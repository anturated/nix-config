# TODO: there's probably fixes for all of this but im stupid
{
  # Monitors — see components/monitors.nix
  # https://wiki.hypr.land/Configuring/Monitors/
  # https://wiki.hypr.land/Configuring/Keywords/#setting-the-configuration
  mon1 = "eDP-2";
  mon2 = "DP-1";

  # Apps
  terminal = "kitty";
  menu = "rofi -show drun";
  browser = "vivaldi";
  fileManager = "dolphin";

  # Keybinds
  mainMod = "SUPER"; # sets "Windows" key as main modifier
  brDevice = "amdgpu_bl2"; # brightness backlight device
}
