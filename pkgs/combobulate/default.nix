{
  lib,
  melpaBuild,
  fetchFromGitHub,
  writeText
}:
melpaBuild {
  pname = "combobulate";
  ename = "combobulate";
  version = "20241110.1947";
  src = fetchFromGitHub {
    owner = "mickeynp";
    repo = "combobulate";
    rev = "e9c5be84062e8183f556d7133d5a477a57e37e51";
    hash = "sha256-r6jObsYx7RRTJUmrCN5h3+0WcHqJA67emhr4/W3rBrM=";
  };
  # elisp dependencies
  # packageRequires = [
  # ];

  recipe = writeText "recipe" ''
    (combobulate :repo "mickeynp/combobulate" :fetcher github)
  '';

  meta = with lib; {
    description = "Combobulate is a package that adds structured editing and movement to a wide range of programming languages";
    homepage = "https://github.com/mickeynp/combobulate";
    license = licenses.gpl3;
    platforms = platforms.all;
  };

}
