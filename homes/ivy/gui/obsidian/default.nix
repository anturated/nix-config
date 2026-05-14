{ config, lib, ... }:

{
  config = lib.mkIf config.ceirios.profiles.graphical {
    # i don't think i'm gonna be using obsidian any time soon.
    # that's too much stuff to set up for what i want from a notes app.
    # AnyType is gonna have to do for the foreseeable future.
    programs.obsidian = {
      enable = false;
    };
  };
}
