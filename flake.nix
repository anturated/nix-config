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
    let
      machines = [
        {
          name = "legion";
          user = "desant";
          arch = "x86_64-linux";
        }
      ];
    in
    {
      # map configs to machines
      nixosConfigurations = nixpkgs.lib.listToAttrs (
        map (machine: {
          # make them accessible by flake.nix#machine
          name = machine.name;
          value = nixpkgs.lib.nixosSystem {
            # inherit stuff
            system = "${machine.arch}";
            specialArgs = {
              host = machine.name;
              user = machine.user;
              inherit inputs;
            };

            # nixos modules
            modules = [
              # machine config
              ./machines/${machine.name}/config.nix
              ./modules/nixos/default.nix

              # custom... ? #

              # home manager config
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  # home-manager modules
                  users.${machine.user}.imports = [
                    ./machines/${machine.name}/home.nix
                    ./modules/home-manager/default.nix
                  ];

                  # inherit stuff to home-manager
                  extraSpecialArgs = {
                    host = machine.name;
                    user = machine.user;
                    inherit inputs;
                  };
                };
              }
            ];
          };
        }) machines
      );
    };
}
