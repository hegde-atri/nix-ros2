{
  description = "A very basic flake";
  inputs = {
    nix-ros-overlay.url = "github:wentasah/nix-ros-overlay";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
    nixgl.url = "github:nix-community/nixGL";
  };
  outputs = { self, nix-ros-overlay, nixgl, nixpkgs }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nix-ros-overlay.overlays.default nixgl.overlay ];
        };
      in
      if system == "aarch64-darwin" then {
        devShell = pkgs.mkShell {
          packages = [
            pkgs.colcon
            (with pkgs.rosPackages.humble; buildEnv {
              paths = [
                ros-core
                geometry-msgs
              ];
            })
          ];
          shellHook = ''
            alias hello='echo "Hello World from macOS!"'
          '';
        };
      } else {
        devShell = pkgs.mkShell {
          packages = [
            pkgs.colcon
            pkgs.nixgl.auto.nixGLDefault
            (with pkgs.rosPackages.humble; buildEnv {
              paths = [
                ros-core
                geometry-msgs
                rviz2
                gazebo
                turtlesim
              ];
            })
          ];
          shellHook = ''
            alias hello='echo "Hello World from non-macOS!"'
            alias gazebo='echo "Work in progress"'
            alias rviz='echo "Work in progress"'
          '';
        };
      });
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
