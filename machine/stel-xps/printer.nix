{ config, pkgs, ...}:
{

  services.printing.drivers = with pkgs; [
    foomatic-filters
    gutenprint
    hplip
  ];
  
  hardware.printers.ensurePrinters = [
    {
      name = "hpm605";
      location = "APB/3014";
      description = "HP Laserjet Enterprise M605DN";
      deviceUri = "hp:/net/HP_LaserJet_M605?hostname=hpm605.tcs.inf.tu-dresden.de";
      model = "HP/hp-laserjet_m604_m605_m606-ps.ppd.gz";
      ppdOptions = {
        Collate = "True";
        HPOption_Duplexer = "True";
        HPOption_Tray4 = "HP500SheetInputTray";
        HPOption_Tray3 = "HP500SheetInputTray";
        MediaType = "Recycled";
        Duplex = "DuplexNoTumble";
      };
    }
    {
      name = "A4";
      location = "APB/3014";
      description = "HP Laserjet 9040";
      deviceUri = "socket://a4.tcs.inf.tu-dresden.de";
      model = "HP/hp-laserjet_9040-ps.ppd.gz";
      ppdOptions = {
        PageSize = "A4";
        HPOption_Tray1 = "True";
        HPOption_Duplexer = "True";
        InstalledMemory = "128-255MB";
        MediaType = "Plain";
        Duplex = "DuplexNoTumble";
        Collate = "True";
      };
    }
    {
      name = "ricoh";
      location = "APB/3014";
      description = "Ricoh SP 4510DN";
      deviceUri = "socket://ricoh.tcs.inf.tu-dresden.de";
      model = "Ricoh/ricoh-sp-4510dn.ppd";
      ppdOptions = {
        OptionTray = "2Cassette";
        PageSize = "A4";
        InputSlot = "3Tray";
        Duplex = "none";
        RIPaperPolicy = "NearestSizeAdjust";
        pdftops-render-default = "pdftocairo";
      };
    }
    {
      name = "ricohcolor";
      location = "APB/3014";
      description = "Ricoh Alficio MP C307";
      deviceUri = "socket://color.tcs.inf.tu-dresden.de";
      model = "Ricoh/ricoh-mp-c307.ppd";
      ppdOptions = {
        media = "A4";
        OptionTray = "1Cassette";
        RIPostScript = "Adobe";
      };
    }
  ];
}
