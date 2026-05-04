
{ config, ... }:
{
  users.users.root = {
    inherit (config.users.users.${config.ceirios.system.mainUser}) hashedPassword;
  };
}
