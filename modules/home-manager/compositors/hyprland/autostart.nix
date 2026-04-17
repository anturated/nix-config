{ ... }:
{
  # https://wiki.hypr.land/Configuring/Keywords/#executing
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = lxqt-policykit-agent
    exec-once = qs -c ivy -d
    exec-once = awww-daemon
    exec-once = hyprsunset
  '';
}
