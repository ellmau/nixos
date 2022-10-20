{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    brightnessctl
    libreoffice-fresh
    onlyoffice-bin
    slack
  ];

  programs = {
    java.enable = true;
  };

  services = {
    autorandr.enable = true;
  };

  virtualisation.podman.enable = true;
  boot.enableContainers = false;

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
