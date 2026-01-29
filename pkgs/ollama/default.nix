{
  ollama,
  fetchFromGitHub
}:
ollama.overrideAttrs (oldAttrs: rec {
  pname = oldAttrs.pname;
  version = "0.13.5";
  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    rev = "v${version}";
    # Set to empty string first, Nix will provide the correct hash on build failure
    hash = "sha256-4K1+GE96Uu5w1otSiP69vNDJ03tFvr78VluIEHMzFGQ=";
  };
  # Ollama is a Go project; you often need to update this hash too
  vendorHash = "sha256-NM0vtue0MFrAJCjmpYJ/rPEDWBxWCzBrWDb0MVOhY+Q=";
})
