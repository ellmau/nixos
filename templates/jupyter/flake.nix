{
  description = "JupyterLab Flake";

  inputs = {
      jupyterWith.url = "github:tweag/jupyterWith";
      flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, jupyterWith, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
      let
        pkgs = import nixpkgs {
          system = system;
          overlays = nixpkgs.lib.attrValues jupyterWith.overlays;
        };
        prince = pkgs.python3Packages.buildPythonPackage rec {
          name = "prince";
          src = pkgs.fetchFromGitHub{
            owner = "MaxHalford";
            repo = "prince";
            rev = "bd5b29fafe853579c9d41e954caa4504d585665d";
            sha256 = "X7gpHvy2cfIKMrfSGLZxmJsytLbe/VZd27VsYIyEoTI=";
          };
          propagatedBuildInputs = with pkgs.python3Packages; [ matplotlib pandas numpy scipy scikit-learn ];
          dontCheck = true;
          dontUseSetuptoolsCheck = true;
        };
        iPython = pkgs.kernels.iPythonWith {
          name = "Python-env";
          packages = p: with p; [ sympy numpy pandas prince ];
          ignoreCollisions = true;
        };
        jupyterEnvironment = pkgs.jupyterlabWith {
          kernels = [ iPython ];
        };
      in rec {
        apps.jupterlab = {
          type = "app";
          program = "${jupyterEnvironment}/bin/jupyter-lab";
        };
        apps.default = apps.jupterlab;
        devShell = jupyterEnvironment.env;
      }
    );
}
