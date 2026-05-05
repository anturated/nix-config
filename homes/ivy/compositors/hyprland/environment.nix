{ osConfig, ... }:

let
  inherit (osConfig.ceirios.hardware) cpu gpu;

  isHybrid = gpu == "nv-hybrid";

  primary = if isHybrid then "/dev/dri/${cpu}-gpu" else "/dev/dri/${gpu}-gpu";
  secondary = if isHybrid then ":/dev/dri/nvidia-gpu" else "";
  devices = primary + secondary;
in
{
  # See https://wiki.hypr.land/Configuring/Environment-variables/
  wayland.windowManager.hyprland.extraConfig = ''

    env = XCURSOR_SIZE,24
    env = XCURSOR_THEME,Volantes Cursors

    # for nvidia
    # env = LIBVA_DRIVER_NAME,nvidia
    # env = __GLX_VENDOR_LIBRARY_NAME,nvidia

    # for prime + whatever, should prioritize igpu,
    # fallback to dgpu + multihead support
    # needs udev rules seen on https://wiki.hypr.land/Configuring/Multi-GPU/#creating-consistent-device-paths-for-specific-cards
    env = AQ_DRM_DEVICES,${devices}
  '';
}
