{
  description = "big hopes for this one";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    kale.url = "path:/home/desant/Documents/projects/kale";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }:
    {
      nixosConfigurations =
        let
          host = "legion";
          user = "desant";
        in
        {
          "${host}" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inherit host;
              inherit user;
              inherit inputs;
            };

            modules = [
              ./hosts/${host}/config.nix
              ./modules/nixos/default.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${user}.imports = [
                    # TODO:
                    ./hosts/${host}/home.nix
                    # TODO:
                    ./modules/home-manager/default.nix
                  ];
                  extraSpecialArgs = {
                    inherit host;
                    inherit inputs;
                    inherit user;
                  };
                };
              }
            ];
          };
        };
    };
}
