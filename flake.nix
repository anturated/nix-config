{
  description = "big hopes for this one";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    awww.url = "git+https://codeberg.org/LGFae/awww";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    kale.url = "path:/home/desant/Documents/projects/kale";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      nix-cachyos-kernel,
      home-manager,
      awww,
      spicetify-nix,
      kale,
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
      kernelOverlays = nix-cachyos-kernel.overlays.pinned;
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

              # custom #
              spicetify-nix.nixosModules.default
              { _module.args.spicetifyPkgs = spicetify-nix.legacyPackages.x86_64-linux; }
              { environment.systemPackages = [ awww.packages.x86_64-linux.default ]; }
              kale.nixosModules.default
              # TODO: make conditional
              nixos-hardware.nixosModules.lenovo-legion-15arh05h

              # cachyos kernel  TODO: make optional?
              {
                nixpkgs.overlays = [ kernelOverlays ];
                nix.settings = {
                  substituters = [ "https://attic.xuyh0120.win/lantian" ];
                  trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
                };
              }

              # home manager config
              home-manager.nixosModules.home-manager
              {
                home-manager = {
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
