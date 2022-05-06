final: prev:

{
  withConfig = config:

    let
      cfg = config.elss.users;
      mapAccount = f: login: prev.nameValuePair login (f login);
      mapList = f: lst: builtins.listToAttrs (map (mapAccount f) lst);
    in
    rec {
      mapUsers = f: mapList f cfg.users;
      mapAdmins = f: mapList f cfg.admins;
      mapAllUsers = f: (mapUsers f) // (mapAdmins f);
      mapAllUsersAndRoot = f: (mapAllUsers f) // {
        root = f "root";
      };
    };
}
