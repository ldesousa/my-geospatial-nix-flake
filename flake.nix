{
  description = "My Geospatial Flake";

  nixConfig = {
    extra-substituters = [
      "https://geonix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "geonix.cachix.org-1:iyhIXkDLYLXbMhL3X3qOLBtRF8HEyAbhPXjjPeYsCl0="
    ];
  };

  inputs = {
    geonix.url = "github:imincik/geospatial-nix";
    nixpkgs.follows = "geonix/nixpkgs";
  };

  outputs = inputs@{ nixgl, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [ "x86_64-linux" ];
      overlays = [ nixgl.overlay ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {

        packages =
          let
            geopkgs = inputs.geonix.packages.${system};
          in

          {
            qgis = (inputs.geonix.packages.${system}.qgis.override {
              extraPythonPackages = p: [
                pkgs.python3Packages.flask
                geopkgs.python3-fiona
                pkgs.nixgl.nixGLIntel
              ];
            });
          };
      };

      flake = { };
    };
}
