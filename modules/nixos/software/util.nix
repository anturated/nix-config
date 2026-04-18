{ pkgs, ... }:

{
  # shadowplay
  programs.gpu-screen-recorder.enable = true;

  environment.systemPackages = with pkgs; [
    # actual command line tools
    wget
    curl
    git
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
    imagemagick

    # convenience
    eza
    bat
    zoxide
    killall
    gh
    hyprshot
    hyprsunset
    appimage-run

    # cli substitutes
    yazi
    btop
    nvtopPackages.full
    lazygit
    gdu
    bluetui

    # gui tools
    pavucontrol
    gnome-calculator
    nautilus
    eog
    piper
    kdePackages.kate
    kdePackages.ark
    vlc
    losslesscut-bin
    okteta
    gnome-disk-utility
    transmission_4-gtk
    coppwr
    anydesk

    # actually no idea where to put these
    usbutils
  ];
}
