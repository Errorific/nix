{ config, lib, pkgs, ... }:

{
  boot.initrd.luks.devices = [
    {
      name = "root";
      # nvme0n1p1 = boot
      # nvme0n1p2 = windows
      # nvme0n1p3 = our nixos luks volume
      device = "/dev/nvme0n1p3";
      preLVM = true;
    }
  ];

  # fonts.fontconfig.dpi = 128;

  services.xserver.videoDrivers = ["intel"];
}
