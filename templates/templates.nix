{
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

  lpyproj = {
    path = ./lpyproj;
    description = ''
      A template for basilisp project
    '';
  };
  
  default = {
    path = ./flake;
    description = ''
      A template to use as a flake starting point
    '';
  };
}
