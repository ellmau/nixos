{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    libreoffice-fresh
    onlyoffice-bin
    krita # drawing tool for my wacom
    slack
  ];

  programs = {
    java.enable = true;
  };

  services = {
    autorandr.enable = false;
  };

  elss = {
    programs = {
      aspell.enable = true;
      # Enable communication programs
      communication.enable = true;
      emacs.enable = true;
      obsstudio.enable = true;
      python.enable = true;
    };

    texlive.enable = true;
    steam-run.enable = true;
  };
}
