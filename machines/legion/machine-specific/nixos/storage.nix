{ ... }:
{
  fileSystems."/run/media/desant/debil" = {
    device = "/dev/disk/by-uuid/ed18b60f-830b-4884-aaa2-6ad3d52d4634";
    fsType = "ext4";
    options = [
      "nofail"
      "x-gvfs-show"
    ];
  };

  fileSystems."/run/media/desant/borderlands3" = {
    device = "/dev/disk/by-uuid/bf2e0f82-4fc6-4940-993f-0d4db339c4ff";
    fsType = "ext4";
    options = [
      "nofail"
      "x-gvfs-show"
    ];
  };
}
