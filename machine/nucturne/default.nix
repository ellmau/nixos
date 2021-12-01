{ config, pkgs, ...}:
{
  variables= {
    hostName = "nucturne";
    graphical = true;
  };
  #networking.hostName = "nucturne"; # define the hostname

  users = {
    users.hpprinter = {
    description = "HP printer access to share";
    shell = pkgs.shadow;
    createHome = false;
    hashedPassword = "$6$qiIL8hOSK1FE7I6H$nAMW86l8O7/oJroOoaqG4WexGRQOOWBV8ooXy3/P7KE8ihQn9x0ScV2/BmvIxeMknGNPQhjD/mjmYn9VcNjAl1";
    isSystemUser = true;
    group = "hpprinter";
    };
    groups.hpprinter = {};
  };
  
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = nucturne
      netbios name = nucturne
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      hosts allow = 192.168.178.222  localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
  '';
    shares = {
      scans = {
        path = "/home/ellmau/scratch/scans";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "ellmau";
        "force group" = "users";
      };
    };
  };
}
