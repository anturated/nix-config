{ ... }:

{
  # NOTE: gamemode just has to be system level for some reason
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
}
