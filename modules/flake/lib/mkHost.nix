{ name, inputs }:

let
  inherit (inputs) nixpkgs self home-manager;
in
nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs self name; };

  modules = [
    { networking.hostName = name; }
    (self + "/machines/${name}/default.nix")

    # shared nixos module tree
    (self + "/modules/nixos/default.nix")

    home-manager.nixosModules.home-manager
    (self + "/modules/home-manager/default.nix")
  ];
}
