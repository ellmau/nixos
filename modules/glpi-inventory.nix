{ config, lib, pkgs, ... }:

with lib; {
  options.kbs.glpi-inventory = {
    enable = mkEnableOption "enable the GLPI inventory service";

    tag = mkOption {
      description =
        "tag used for associating the system to an organisational unit";
      example = "10002205"; # KBS group
      type = types.str;
    };

    url = mkOption {
      description = "URL for submission to the GLPI server";
      default = "https://glpi.tu-dresden.de/marketplace/glpiinventory/";
      type = types.str;
    };

    onCalendar = mkOption {
      description =
        "When to run the GLPI inventory. See systemd.time(7) for more information about the format.";
      default = "daily";
      type = types.str;
    };

    scanHomedirs = mkOption {
      description = "scan user homedirs for software";
      default = false;
      type = types.bool;
    };

    scanProfiles = mkOption {
      description = "scan user profiles for software";
      default = false;
      type = types.bool;
    };

    noCategories = mkOption {
      description = "categories to exclude from the inventory";
      default = [
        "environment"
        "process"
        "local_group"
        "local_user"
        "user"
        "printer"
        "usb"
      ];
      type = types.listOf (types.enum [
        "accesslog"
        "antivirus"
        "battery"
        "bios"
        "controller"
        "cpu"
        "database"
        "drive"
        "environment"
        "firewall"
        "hardware"
        "input"
        "licenseinfo"
        "local_group"
        "local_user"
        "lvm"
        "memory"
        "modem"
        "monitor"
        "network"
        "os"
        "port"
        "printer"
        "process"
        "provider"
        "psu"
        "registry"
        "remote_mgmt"
        "rudder"
        "slot"
        "software"
        "sound"
        "storage"
        "usb"
        "user"
        "video"
        "virtualmachine"
      ]);
    };
  };

  config = let
    cfg = config.kbs.glpi-inventory;
    noCategories = concatStringsSep "," cfg.noCategories;
    inventoryArgs = concatStringsSep " " (concatLists [
      [ "--tag=${cfg.tag}" ]
      (optional cfg.scanHomedirs "--scan-homedirs")
      (optional cfg.scanProfiles "--scan-profiles")
      (optional (noCategories != "") "--no-category=${noCategories}")
    ]);
  in mkIf cfg.enable {
    systemd = {
      services.glpi-submit-inventory = {
        description = "Run the GLPI inventory and submit the results";

        serviceConfig = {
          CPUSchedulingPolicy = "idle";
          IOSchedulingClass = "idle";
          PrivateTmp = true;
          DynamicUser = true;

          ExecStart = let
            submitInventory = pkgs.writeShellScript "glpi-write-inventory" ''
              ${pkgs.glpi-agent}/bin/glpi-inventory ${inventoryArgs} > /tmp/inventory.xml
              ${pkgs.glpi-agent}/bin/glpi-injector --file /tmp/inventory.xml --url ${cfg.url} --no-compression
            '';
          in "!${submitInventory}";
        };

        requires = [ "network-online.target" ];
      };

      timers.glpi-submit-inventory = {
        description = "Run the GLPI inventory and submit the results";

        timerConfig = {
          Unit = "glpi-submit-inventory.service";
          OnCalendar = cfg.onCalendar;
          Persistent = true;
        };

        wantedBy = [ "timers.target" ];
      };
    };

    # make sure we don't accidentally submit inventories for VM builds.
    virtualisation = let
      glpiInventory = {
        kbs.glpi-inventory.url = "http://localhost/glpiinventory";
      };
    in {
      vmVariant = glpiInventory;
      vmVariantWithBootLoader = glpiInventory;
    };
  };
}
