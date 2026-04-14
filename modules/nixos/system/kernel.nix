{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.machine.kernel.cachyos;
  supportsArch = builtins.elem cfg.variant [
    "latest"
    "lts"
  ];
  # make flake name
  pkgAttr =
    let
      base = "linuxPackages-cachyos-${cfg.variant}";
      withLto = if cfg.lto then "${base}-lto" else base;
      withArch = if cfg.arch != null && supportsArch then "${withLto}-${cfg.arch}" else withLto;
    in
    withArch;
in
{
  config = lib.mkMerge [
    # derive cachyos.variant from kernel.lts unless explicitly set
    {
      machine.kernel.cachyos.variant = lib.mkDefault (
        if config.machine.kernel.lts then "lts" else "latest"
      );
    }

    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.arch == null || supportsArch;
          message = ''
            kernel.cachyos.arch = "${toString cfg.arch}" is only valid when
            kernel.cachyos.variant is "latest" or "lts".
            The "${cfg.variant}" variant ships a single generic build.
          '';
        }
      ];
      boot.kernelPackages = pkgs.cachyosKernels.${pkgAttr};
    })

    (lib.mkIf (!cfg.enable) {
      boot.kernelPackages =
        if config.machine.kernel.lts then pkgs.linuxPackages else pkgs.linuxPackages_latest;
    })
  ];
}
