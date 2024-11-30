{
  lib,
  trivialBuild,
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
    hash = "sha256-ZX7F09s8lefhA07BJPz2aSxpsHIuuM1ZzX2qMWxsaDo=";
  };

  # elisp dependencies
  propagatedUserEnvPkgs = [
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
