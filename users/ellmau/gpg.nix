{ config, pkgs, lib, ...}:
{
  home-manager.users.ellmau = {
    home.file = {
      ".gnupg/gpgsm.conf".text = ''
      keyserver ldap.pca.dfn.de::::o=DFN-Verein,c=DE
      disable-crl-checks
    '';
      ".gnupg/dirmngr_ldapservers.conf".text = "ldap.pca.dfn.de:389:::o=DFN-Verein,c=de,o=DFN-Verein,c=de";
      ".gnupg/trustlist.txt".source = ./conf/gpgsm/trustlist.txt;
      ".gnupg/chain.txt".source = ./conf/gpgsm/chain.txt;
    };

    

    programs.gpg.enable = true;
  };
}
