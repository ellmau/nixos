{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}:
with lib; {
  config = let
    cfg = nixosConfig.elss.graphical.xserver.autorandr;
  in
    mkIf cfg.enable {
      #services.autorandr = { enable = true; };
      programs.autorandr = {
        enable = true;
        profiles = {
          "home" = {
            fingerprint = {
              DP-1 = "00ffffffffffff0009d1507945540000221e0104b54627783f5995af4f42af260f5054a56b80d1c0b300a9c08180810081c0010101014dd000a0f0703e8030203500ba892100001a000000ff004e384c30323634373031390a20000000fd00283c87873c010a202020202020000000fc0042656e5120455733323730550a01bc02033af1515d5e5f6061101f222120051404131203012309070783010000e200c06d030c0020003878200060010203e305e001e6060501544c2ca36600a0f0701f8030203500ba892100001a565e00a0a0a029502f203500ba892100001abf650050a0402e6008200808ba892100001c000000000000000000000000000000bf";
              eDP-1 = "00ffffffffffff0006af2b2800000000001c0104a51d117802ee95a3544c99260f50540000000101010101010101010101010101010152d000a0f0703e803020350025a51000001a000000000000000000000000000000000000000000fe0039304e544880423133335a414e0000000000024103a8011100000b010a20200006";
            };
            config = {
              eDP-1.enable = false;
              DP-1 = {
                enable = true;
                crtc = 1;
                primary = true;
                position = "0x0";
                mode = "3840x2160";
                dpi = 96;
              };
            };
          };
          "mobile" = {
            fingerprint.eDP-1 = "00ffffffffffff0006af2b2800000000001c0104a51d117802ee95a3544c99260f50540000000101010101010101010101010101010152d000a0f0703e803020350025a51000001a000000000000000000000000000000000000000000fe0039304e544880423133335a414e0000000000024103a8011100000b010a20200006";
            config = {
              eDP-1 = {
                enable = true;
                primary = true;
                mode = "3840x2160";
                dpi = 192;
              };
            };
          };
          "work_new" = {
            fingerprint = {
              eDP-1 = "00ffffffffffff0006af2b2800000000001c0104a51d117802ee95a3544c99260f50540000000101010101010101010101010101010152d000a0f0703e803020350025a51000001a000000000000000000000000000000000000000000fe0039304e544880423133335a414e0000000000024103a8011100000b010a20200006";
              DP-2 = "00ffffffffffff0009d13d804554000024210104b54627783e6875a6564fa2260e5054a56b80d1c0b300a9c08180810081c0010101014dd000a0f0703e8030203500b9882100001a000000ff0035395030303831353031390a20000000fd00324c1e873c010a202020202020000000fc0042656e5120504433323035550a014c020338f14f5d5e5f6061101f22212004131203012309070783010000e200cf6d030c0010003878200060010203e305c301e6060501626200565e00a0a0a0295030203500b9882100001e4d6c80a070703e8030203a00b9882100001a0000000000000000000000000000000000000000000000000000000000000000000000c7";
            };
            config = {
              eDP-1 = {
                enable = true;
                crtc = 0;
                position = "3840x0";
                mode = "3840x2160";
                #dpi = 288;
                dpi = 96;
              };
              DP-2 = {
                enable = true;
                primary = true;
                mode = "3840x2160";
                #dpi = 144;
                dpi = 96;
                position = "0x0";
              };
            };
          };
          "work" = {
            fingerprint = {
              eDP-1 = "00ffffffffffff0006af2b2800000000001c0104a51d117802ee95a3544c99260f50540000000101010101010101010101010101010152d000a0f0703e803020350025a51000001a000000000000000000000000000000000000000000fe0039304e544880423133335a414e0000000000024103a8011100000b010a20200006";
              DP-2 = "00ffffffffffff0010acb5414c4133452c1e0104b53c22783eee95a3544c99260f5054a54b00e1c0d100d1c0b300a94081808100714f4dd000a0f0703e803020350055502100001a000000ff0031444e593132330a2020202020000000fd00184b1e8c36010a202020202020000000fc0044454c4c205532373230510a2001af020319f14c101f2005140413121103020123097f0783010000a36600a0f0703e803020350055502100001a565e00a0a0a029503020350055502100001a11
4400a0800025503020360055502100001a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d9";
            };
            config = {
              eDP-1 = {
                enable = true;
                crtc = 0;
                position = "3840x0";
                mode = "3840x2160";
                #dpi = 288;
                dpi = 96;
              };
              DP-2 = {
                enable = true;
                primary = true;
                mode = "3840x2160";
                #dpi = 144;
                dpi = 96;
                position = "0x0";
              };
            };
          };
          "home-nuc" = {
            fingerprint = {
              DP-2 = "00ffffffffffff0009d1507945540000221e0104b54627783f5995af4f42af260f5054a56b80d1c0b300a9c08180810081c0010101014dd000a0f0703e8030203500ba892100001a000000ff004e384c30323634373031390a20000000fd00283c87873c010a202020202020000000fc0042656e5120455733323730550a01bc02033af1515d5e5f6061101f222120051404131203012309070783010000e200c06d030c0020003878200060010203e305e001e6060501544c2ca36600a0f0701f8030203500ba892100001a565e00a0a0a029502f203500ba892100001abf650050a0402e6008200808ba892100001c000000000000000000000000000000bf";
            };
            config = {
              DP-2 = {
                enable = true;
                crtc = 1;
                primary = true;
                position = "0x0";
                mode = "3840x2160";
                dpi = 96;
              };
            };
          };

          "e3027" = {
            fingerprint = {
              e-DP1 = "00ffffffffffff0006af2b2800000000001c0104a51d117802ee95a3544c99260f50540000000101010101010101010101010101010152d000a0f0703e803020350025a51000001a000000000000000000000000000000000000000000fe0039304e544880423133335a414e0000000000024103a8011100000b010a20200006";
              DP-1 = "00ffffffffffff004ca306a7010101011715010380a05a780ade50a3544c99260f5054a10800814081c0950081809040b300a9400101283c80a070b023403020360040846300001a9e20009051201f304880360040846300001c000000fd0017550f5c11000a202020202020000000fc004550534f4e20504a0a202020200116020328f651901f202205140413030212110706161501230907078301000066030c00100080e200fd023a801871382d40582c450040846300001e011d801871382d40582c450040846300001e662156aa51001e30468f330040846300001e302a40c8608464301850130040846300001e00000000000000000000000000000089";
            };
            config = {
              eDP-1 = {
                enable = true;
                crtc = 0;
                position = "0x0";
                mode = "3840x2160";
              };
              DP-1 = {
                enable = true;
                crtc = 1;
                position = "3840x0";
                mode = "1920x1200";
              };
            };
          };

          "e3027-clone" = {
            fingerprint = {
              e-DP1 = "00ffffffffffff0006af2b2800000000001c0104a51d117802ee95a3544c99260f50540000000101010101010101010101010101010152d000a0f0703e803020350025a51000001a000000000000000000000000000000000000000000fe0039304e544880423133335a414e0000000000024103a8011100000b010a20200006";
              DP-1 = "00ffffffffffff004ca306a7010101011715010380a05a780ade50a3544c99260f5054a10800814081c0950081809040b300a9400101283c80a070b023403020360040846300001a9e20009051201f304880360040846300001c000000fd0017550f5c11000a202020202020000000fc004550534f4e20504a0a202020200116020328f651901f202205140413030212110706161501230907078301000066030c00100080e200fd023a801871382d40582c450040846300001e011d801871382d40582c450040846300001e662156aa51001e30468f330040846300001e302a40c8608464301850130040846300001e00000000000000000000000000000089";
            };
            config = {
              eDP-1 = {
                enable = true;
                crtc = 0;
                position = "0x0";
                mode = "1920x1200";
              };
              DP-1 = {
                enable = true;
                crtc = 1;
                position = "0x0";
                mode = "1920x1200";
              };
            };
          };
        };
        hooks.postswitch = {
          "polybar" = "systemctl --user restart polybar.service";
          change-bg = "/home/ellmau/.fehbg";
        };
      };
    };
}
