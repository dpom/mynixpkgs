{ stdenv, lib, fetchFromGitHub, python39, qt5 }:
let
  python = python39;
in   
python.pkgs.buildPythonApplication rec {
  pname = "rmview";
  version = "3.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bordaigorl";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-V26zmu8cQkLs0IMR7eFO8x34McnT3xYyzlZfntApYkk=";
  };

  nativeBuildInputs = [ python.pkgs.pyqt5
                        python.pkgs.setuptools
                        python.pkgs.zope-interface
                        qt5.qtbase
                        qt5.wrapQtAppsHook ];
  propagatedBuildInputs = with python.pkgs; [ pyqt5
                                              paramiko
                                              zope-interface
                                              twisted
                                              pyjwt
                                              pyopenssl
                                              service-identity
                                              sshtunnel ];
  
  preBuild = ''
    pyrcc5 -o src/rmview/resources.py resources.qrc
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Fast live viewer for reMarkable 1 and 2";
    mainProgram = "rmview";
    homepage = "https://github.com/bordaigorl/rmview";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.nickhu ];
  };
}
