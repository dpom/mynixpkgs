{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk25,
  gnused,
  autoPatchelfHook,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "dbeaver";
  version = "24.2.1";
  hash = "535289c44d4fcd144cbd8c378d2615da7e89ba1cf22f7d257b51de63491fb759";
  jdk = jdk25;
  jdk_home = jdk25.home;
  
  src = fetchurl {
    url = "https://dbeaver.io/files/${version}/dbeaver-ce-${version}-linux.gtk.x86_64-nojdk.tar.gz";
    sha256 = "${hash}";
  };

  nativeBuildInputs = [
    makeWrapper
    gnused
    wrapGAppsHook3
    autoPatchelfHook
];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
        mkdir -p $out/opt/dbeaver $out/bin
        cp -r * $out/opt/dbeaver
        makeWrapper $out/opt/dbeaver/dbeaver $out/bin/dbeaver \
          --prefix PATH : "${jdk}/bin" \
          --set JAVA_HOME "${jdk_home}}"

        mkdir -p $out/share/icons/hicolor/256x256/apps
        ln -s $out/opt/dbeaver/dbeaver.png $out/share/icons/hicolor/256x256/apps/dbeaver.png

        mkdir -p $out/share/applications
        ln -s $out/opt/dbeaver/dbeaver-ce.desktop $out/share/applications/dbeaver.desktop

        substituteInPlace $out/opt/dbeaver/dbeaver-ce.desktop \
          --replace-fail "/usr/share/dbeaver-ce/dbeaver.png" "dbeaver" \
          --replace-fail "/usr/share/dbeaver-ce/dbeaver" "$out/bin/dbeaver"

        sed -i '/^Path=/d' $out/share/applications/dbeaver.desktop
      '';


  meta = with lib; {
    homepage = "https://dbeaver.io/";
    description = "Universal SQL Client for developers, DBA and analysts. Supports MySQL, PostgreSQL, MariaDB, SQLite, and more";
    longDescription = ''
      Free multi-platform database tool for developers, SQL programmers, database
      administrators and analysts. Supports all popular databases: MySQL,
      PostgreSQL, MariaDB, SQLite, Oracle, DB2, SQL Server, Sybase, MS Access,
      Teradata, Firebird, Derby, etc.
    '';
    license = licenses.asl20;
    mainProgram = "dbeaver";
  };
}
