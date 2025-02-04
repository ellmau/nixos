{
  pkgs,
  config,
  ...
}: {
  config = {
    nix = {
      settings = {
        sandbox = true;
        trusted-users = ["root"] ++ config.elss.users.admins;
        auto-optimise-store = true;
      };
      package = pkgs.nixVersions.stable;
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;

      # Enable flakes
      # Free up to 50 GiB whenever there is less than 10 GiB left.
      extraOptions = ''
        experimental-features = nix-command flakes
        min-free = ${toString (10 * 1024 * 1024 * 1024)}
        max-free = ${toString (50 * 1024 * 1024 * 1024)}
      '';

      # Disable automatic (periodic) GC, since it might interfere with benchmarks
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  };
}
