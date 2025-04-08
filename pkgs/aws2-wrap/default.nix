{ lib, pkgs, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "aws2-wrap";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linaro-its";
    rev = "c27852d5f0f79ec558248c59586ff134fb35fb7a";
    repo = pname;
    sha256 = "sha256-k1wGJ+HmlCYdoR1hWAXVIsV62oDK5jLZoJQAcbFiP/0=";
  };

  nativeBuildInputs = [
    python3Packages.pyqt5
    python3Packages.setuptools
    pkgs.psutils
  ];
  
  propagatedBuildInputs = with python3Packages; [
    green
    mypy
    mypy-extensions
    psutil
    pyfakefs
    pyqt5
    pylint
    types-psutil
  ];


  meta = with lib; {
    description = "This is a simple script to make it easier to use AWS Single Sign On credentials with tools that don't understand the sso entries in an AWS profile.";
    mainProgram = "aws2-wrap";
    homepage = "https://github.com/linaro-its/aws2-wrap";
    license = licenses.gpl3Only;
  };
}
