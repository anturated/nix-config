{ lib, inputs }:
let
  inherit (inputs) nixpkgs self home-manager;

  inherit (lib)
    recursiveUpdate
    concatLists
    singleton
    optionals
    ;
in

name:
{
  arch ? "x86_64",
  class ? "nixos",
  modules ? [ ],
  specialArgs ? { },
  ...
}:
let
  inherit (inputs) nixpkgs;

  os =
    {
      iso = "linux";
      wsl = "linux";
      nixos = "linux";
    }
    .${class} or class;
  system = "${arch}-${os}";

  evalHost =
    if class == "darwin" then
      # darwin.lib.darwinSystem
      throw "Darwin not yet supported."
    else
      nixpkgs.lib.nixosSystem;
in
evalHost {
  # very overrideable specialArgs
  specialArgs = recursiveUpdate {
    # inputs.self & self are the same thing, extra support
    inherit inputs self;

    # used by many rice options i'm not remaking all that
    host = name;
  } specialArgs;

  modules = concatLists [
    [
      # import machine settings
      "${self}/machines/${name}/default.nix"

      # os/class specific
      "${self}/modules/${class}/default.nix"
    ]

    # this will likely be done elsewhere
    # home-manager.nixosModules.home-manager
    # (self + "/modules/home-manager/default.nix")

    (singleton {
      key = "ceirios#hostname";
      _file = "${__curPos.file}";

      # do this here to avoid duping across multiple classes
      networking.hostName = name;
    })

    (singleton {
      key = "ceirios#nixpkgs";
      _file = "${__curPos.file}";

      nixpkgs = {
        # do this to skip hardware-config
        hostPlatform = system;

        # needed for the build
        flake.source = nixpkgs.outPath;
      };
    })

    (optionals (class == "darwin") (singleton {
      key = "ceirios#nixpkgs-darwin";
      _file = "${__curPos.file}";

      # darwin complains on build unless set
      nixpkgs.source = nixpkgs;
    }))

    # extra modules from args
    modules
  ];
}
