{
  lib,
  perlPackages,
  nix,
  dmidecode,
  pciutils,
  usbutils,
  iproute2,
  nettools,
  fetchFromGitHub,
  makeWrapper,
  libredirect,
  iana-etc,
  xrandr,
  xdpyinfo,
  procps,
  which,
}:
perlPackages.buildPerlPackage {
  pname = "glpi-agent";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "glpi-project";
    repo = "glpi-agent";
    rev = "1.5";
    sha256 = "l5ist5a07X4IG0OsYjqwMvhA5UN9/CxXrVcfhNTaBgc=";
  };

  patches = [
    ./0001-Fix-test-for-UTC-timezone.patch
    ./0002-Add-skip-for-software-inventory-test.patch
    ./0003-Do-not-run-the-GC-to-determine-what-is-in-the-nix-st.patch
  ];

  postPatch = ''
    patchShebangs bin

    substituteInPlace "lib/GLPI/Agent/Tools/Linux.pm" \
      --replace /sbin/ip ${iproute2}/sbin/ip
    substituteInPlace "lib/GLPI/Agent/Task/Inventory/Linux/Networks.pm" \
      --replace /sbin/ip ${iproute2}/sbin/ip
  '';

  buildTools = [];
  nativeBuildInputs = [makeWrapper procps];
  buildInputs = with perlPackages; [
    CGI
    CpanelJSONXS
    DataStructureUtil
    DataUUID
    DateTime
    FileCopyRecursive
    HTTPDaemon
    HTTPProxy
    HTTPServerSimple
    HTTPServerSimpleAuthen
    IOCapture
    IOSocketSSL
    IPCRun
    JSON
    LWPProtocolHttps
    ModuleInstall
    NetSNMP
    ParallelForkManager
    TestCPANMeta
    TestCompile
    TestDeep
    TestException
    TestMockModule
    TestMockObject
    TestNoWarnings
    XMLLibXML
  ];
  propagatedBuildInputs = with perlPackages; [
    FileWhich
    LWP
    NetIP
    TextTemplate
    UNIVERSALrequire
    XMLTreePP
  ];

  installPhase = ''
    mkdir -p $out

    cp -r bin $out
    cp -r lib $out
    cp -r share $out

    for cur in $out/bin/*; do
      if [ -x "$cur" ]; then
        sed -e "s|./lib|$out/lib|" -i "$cur"
        wrapProgram "$cur" --prefix PATH : ${
      lib.makeBinPath [
        nix
        dmidecode
        iproute2
        nettools
        pciutils
        procps
        usbutils
        xdpyinfo
        xrandr
        which
      ]
    }
      fi
    done
  '';

  preCheck = let
    inherit (lib) concatStringsSep mapAttrsToList;
    redirects = {
      "/etc/protocols" = "${iana-etc}/etc/protocols";
      "/etc/services" = "${iana-etc}/etc/services";
    };
    REDIRECTS =
      concatStringsSep ":"
      (mapAttrsToList (from: to: "${from}=${to}") redirects);
  in ''
    export NIX_REDIRECTS="${REDIRECTS}" \
      LD_PRELOAD=${libredirect}/lib/libredirect.so \
      GLPI_SKIP_SOFTWARE_INVENTORY_TEST=1
  '';
  postCheck = ''
    unset NIX_REDIRECTS LD_PRELOAD GLPI_SKIP_SOFTWARE_INVENTORY_TEST
  '';

  outputs = ["out"];

  meta = {
    homepage = "https://glpi-project.org/";
    description = "GLPI unified Agent for UNIX, Linux, Windows and MacOSX";
    license = lib.licenses.gpl2;
  };
}
