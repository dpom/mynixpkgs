{
  lib,
  trivialBuild,
  dash,
  seq,
  fetchFromGitHub
}:
trivialBuild rec {
  pname = "ent";
  version = "v2.0";
  src = fetchFromGitHub {
    owner = "dpom";
    repo = "ent";
    rev = version;
    hash = "sha256-VaqZoCfx38bOhIbihTxV8/z6SH//WW+QQeIECIilDX4=";
  };

  # elisp dependencies
  propagatedUserEnvPkgs = [
    dash
    seq
  ];
  buildInputs = propagatedUserEnvPkgs;
  
  meta = with lib; {
    description = "A build tool like ant but working inside emacs and using elisp syntax";
    homepage = "https://github.com/dpom/ent";
    license = licenses.gpl3;
    platforms = platforms.all;
  };

}
