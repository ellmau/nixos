{ stdenv
, python3
, gtk3
, gobject-introspection
, wrapGAppsHook
, lib
}:

stdenv.mkDerivation rec {
  pname = "tray-calendar";
  version = "0.9";
  src = ./traycalendar.py;

  buildInputs = [
    (python3.withPackages (pyPkgs: with pyPkgs; [
      pygobject3
    ]))
    gtk3
    gobject-introspection
  ];
  nativeBuildInputs = [ wrapGAppsHook ];

  dontUnpack = true;
  installPhase = "install -m755 -D $src $out/bin/traycalendar";
  meta = {
    license = lib.licenses.gpl3Only;
    homepage = "https://github.com/vifon/TrayCalendar";
  };
}
