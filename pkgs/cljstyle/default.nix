{ stdenv, fetchurl, unzip }:
let
  name = "cljstyle";
  version = "0.16.626";
in
stdenv.mkDerivation rec {
  pname = "${name}";
  inherit version;
  src = fetchurl {
    url = "https://github.com/greglook/cljstyle/releases/download/${version}/cljstyle_${version}_linux_amd64_static.zip";
    sha256 = "01d29478533d6107fd43f369bfaa9053d83a5bdb8f96153292e9a7b7475c4043";
  };
  buildInputs = [ unzip ];
  unpackPhase = ''
  unzip ${src} -d .
    '';
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp ./cljstyle $out/bin
    chmod a+x $out/bin/cljstyle
   '';
  
}
