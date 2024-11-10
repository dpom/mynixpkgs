{
  lib,
  trivialBuild,
  fetchFromGitHub,
}:
trivialBuild {
  pname = "combobulate";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "mickeynp";
    repo = "combobulate";
    rev = "e9c5be84062e8183f556d7133d5a477a57e37e51";
    hash = "sha256-r6jObsYx7RRTJUmrCN5h3+0WcHqJA67emhr4/W3rBrM=";
  };
  # elisp dependencies
  # packageRequires = [
  # ];

  meta = with lib; {
    description = "Combobulate is a package that adds structured editing and movement to a wide range of programming languages";
    homepage = "https://github.com/mickeynp/combobulate";
    license = licenses.gpl3;
    platforms = platforms.all;
  };

}
