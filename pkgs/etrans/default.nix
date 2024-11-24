{
  lib,
  trivialBuild,
  request,
  fetchFromGitHub
}:
trivialBuild rec {
  pname = "etrans";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "dpom";
    repo = "etrans";
    rev = "acb457413db4ed4873b58838435f4a3e6b7d2474";
    hash = "sha256-ZX7F09s8lefhA07BJPz2aSxpsHIuuM1ZzX2qMWxsaDo=";
  };

  # elisp dependencies
  propagatedUserEnvPkgs = [
    request
  ];
  buildInputs = propagatedUserEnvPkgs;
  
  meta = with lib; {
    description = "implement an emacs command that will replace the selected text with a translation into another language";
    homepage = "https://github.com/dpom/etrans";
    license = licenses.gpl3;
    platforms = platforms.all;
  };

}
