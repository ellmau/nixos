# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/da267a3c-34e3-4218-933f-10738ee61eb6";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/9ebd7aff-629b-449b-83d8-6381a04eb708";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DE6D-C383";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/0069f1fa-dd8e-4c0a-8f01-a576af29909e"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
