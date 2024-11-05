rec {
  cljproj = {
    path = ./cljproj;
    description = ''
      A template for clojure project
    '';
  };

  pyproj = {
    path = ./pyproj;
    description = ''
      A template for python project
    '';
  };
  
  flake = {
    path = ./flake;
    description = ''
      A template to use as a flake starting point
    '';
  };

  default = flake;
}
