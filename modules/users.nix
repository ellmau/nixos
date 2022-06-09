{ config, pkgs, lib, homeConfigurations, ... }:

with lib; {
  options.elss.users = {
    enable = mkEnableOption "elss specific user configuration";

    x11.enable = mkEnableOption "Activate XSession related options in user-configs";

    users = mkOption {
      description = "logins of non-admin users to configure";
      type = types.listOf types.str;
    };
    admins = mkOption {
      description = "logins of admin users to configure";
      type = types.listOf types.str;
    };
    meta = mkOption {
      type = types.attrsOf
        (types.submodule {
          options = {
            description = mkOption {
              type = types.str;
              description = "full name of the user";
            };
            hashedPassword = mkOption
              {
                type = types.str;
                default = null;
                description = "hashed password, only required for admins";
              };
            publicKeys = mkOption {
              type = types.listOf types.str;
              description = "SSH public keys for the user";
            };
            mailAddress = mkOption {
              type = types.str;
              description = "Email address of the user";
            };
            git = mkOption {
              type = types.submodule {
                  options = {
                    key = mkOption {
                      type = types.str;
                      example = "0xBEEE1234";
                      default = "C804A9C1B7AF8256";
                      description = "Signkey for git commits";
                    };
                    gpgsm = mkOption {
                      type = types.bool;
                      default = false;
                      description = "Whether to use gpgsm for commit signatures";
                    };
                    signDefault = mkOption {
                      type = types.bool;
                      default = false;
                      description = "Whether to force signing commits or not";
                    };
                  };
                };
            };
          };
        });
    };
  };

  config =
    let
      cfg = config.elss.users;
      inherit (elss.withConfig config) mapAdmins mapUsers mapAllUsersAndRoot mapAllUsers;

      getMeta = login:
        builtins.getAttr login cfg.meta;
      mkAdmin = login:
        mkMerge [
          (mkUser login)
          {
            extraGroups = [ "wheel" ];
            inherit (getMeta login) hashedPassword;
          }
        ];
      mkUser = login:
        let meta = getMeta login;
        in
        {
          inherit (meta) description;
          isNormalUser = true;
          home = "/home/${login}";
          extraGroups = [ ];
          openssh.authorizedKeys.keys = meta.publicKeys;
        };

      mkGitUser = login:
        let meta = getMeta login;
        in
        {
          programs.git = {
            userEmail = meta.mailAddress;
            userName = meta.description;
            extraConfig = {
              gpg = lib.mkIf meta.git.gpgsm {
                format = "x509";
                program = "${pkgs.gnupg}/bin/gpgsm";
              };
              user = {
                signingKey = meta.git.key;
              };
              commit = {
                gpgsign = meta.git.signDefault;
              };
            };
          };
        };

      mkX11User = login:
        let meta = getMeta login;
        in
        mkIf (cfg.x11.enable)
          {
            xsession = {
              numlock.enable = true;
              profileExtra = ''
                if [ $(hostname) = 'stel-xps' ]; then
                  brightnessctl s 50%
                fi
              '';
            };
            home.file.".background-image".source = ../common/wallpaper/nix-wallpaper-nineish-dark-gray.png;

            services = {
              blueman-applet.enable = true;
              network-manager-applet.enable = true;
              dunst.enable = true;
            };
          };

    in
    mkIf (cfg.enable)
      {
        assertions =
          let
            cfg = config.elss.users;
          in
          [
            {
              assertion = mutuallyExclusive cfg.users cfg.admins;
              message = "elss.users.users and elss.users.admins are mutually exclusive";
            }
            {
              assertion = all (hash: hash != "")
                (catAttrs "hashedPassword" (attrVals cfg.admins cfg.meta));
              message = "No admin without password";
            }
            {
              assertion = length (cfg.admins) > 0;
              message = "One admin needed at least";
            }
          ];

        users = {
          mutableUsers = false;
          users =
            mkMerge [
              (mapAdmins mkAdmin)
              (mapUsers mkUser)
            ];
        };
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          users =
          mkMerge [
            (mapAllUsers mkX11User)
            (mapAllUsers mkGitUser)
            (mapAllUsersAndRoot (login:
              mkMerge [
                { config.home.stateVersion = mkDefault "21.11"; }
                (if homeConfigurations ? "${login}" then homeConfigurations."${login}" else { })
              ]))
          ];
        };

      };
}
