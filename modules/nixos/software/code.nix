{
  pkgs,
  lib,
  ...
}:

{
  # docker
  virtualisation.docker.enable = true;
  systemd.services.docker.wantedBy = lib.mkForce [ ]; # Don't start on boot
  systemd.sockets.docker.wantedBy = [ "sockets.target" ]; # Start the socket instead

  environment.systemPackages = with pkgs; [
    # system-wide LSPs
    nil # for nix
    hyprls # for hypr (duh)
    lua-language-server

    # TODO: add lua_ls

    kdePackages.qtdeclarative # for qmlls
  ];

  # TODO: also set up nix-direnv
  # TODO: change shell to fish probably?
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    bash.enable = true; # see note on other shells below
  };
}
