{
  cljproj = {
    path = ./cljproj;
    description = ''
      A template for clojure projects
    '';
  };

  awsproj = {
    path = ./awsproj;
    description = ''
      A template for clojure aws projects
    '';
  };

  pyproj = {
    path = ./pyproj;
    description = ''
      A template for python projects
    '';
  };

  lpyproj = {
    path = ./lpyproj;
    description = ''
      A template for basilisp projects
    '';
  };

  default = {
    path = ./flake;
    description = ''
      A template to use as a flake starting point
    '';
  };
}
