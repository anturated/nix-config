{ pkgs, ... }:

{
  ceirios.packages = {
    inherit (pkgs)
      wget
      curl
      brightnessctl
      playerctl
      zip
      unzip
      wl-clipboard
      xclip
      jq
      fzf
      ripgrep
      asdf-vm

      # convenience
      imagemagick
      eza
      bat
      zoxide
      killall

      # no idea
      usbutils
      ;
  };
}
