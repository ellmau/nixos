{ config, pkgs, lib, ... }:

with lib; {
  options.elss.users = {
    enable = mkEnableOption "elss specific user configuration";

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
          };
        });
    };
  };

  config =
    let
      cfg = config.elss.users;
      inherit (elss.withConfig config) mapAdmins mapUsers mapAllUsersAndRoot;

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
                  message = "kbs.users.users and kbs.users.admins are mutually exclusive";
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
        };
}
