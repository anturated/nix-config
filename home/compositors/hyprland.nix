{ ... }:

{
  # https://wiki.hypr.land/Configuring/Configuring-Hyprland/
  imports = [
    ./hyprland/autostart.nix
    ./hyprland/environment.nix
    ./hyprland/permissions.nix
    ./hyprland/look_and_feel.nix
    ./hyprland/input.nix
    ./hyprland/keybinds.nix
    ./hyprland/monitors.nix
    ./hyprland/windows_and_workspaces.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
  };

  # xdg-desktop-portal-hyprland config
  # https://wiki.hypr.land/Hypr-Ecosystem/xdg-desktop-portal-hyprland/
  xdg.configFile."hypr/xdph.conf".text = ''
    screencopy {
      max_fps = 60
      allow_token_by_default = true
    }
  '';
}
