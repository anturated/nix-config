# See https://wiki.hypr.land/Configuring/Monitors/
let
  vars = import ./_vars.nix;
in
{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "${vars.mon1}, 1920x1080@120, 0x0, 1"
      "${vars.mon2}, preferred, 1920x100, 1"
    ];
  };
}
