{ pkgs, ... }:

{
  # i don't need all that, this'll do
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "llin";

      runtimeInputs = with pkgs; [
        nix
        gum
        vim
        parted
        nixos-install-tools
      ];

      text = builtins.readFile ./llin.sh;
    })
  ];
}
