{
  description = "A very basic flake";
  inputs = {
    nix-ros-overlay.url = "github:wentasah/nix-ros-overlay";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
  };
  outputs = { self, nix-ros-overlay, nixpkgs }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nix-ros-overlay.overlays.default ];
        };
      in
      if system == "aarch64-darwin" then {
        devShell = pkgs.mkShell {
          packages = with pkgs.rosPackages.humble; [
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
          packages = with pkgs.rosPackages.humble; [
            pkgs.colcon
            (with pkgs.rosPackages.humble; buildEnv {
              paths = [
                ros-core
                geometry-msgs
                rviz2
                gazebo
              ];
            })
          ];
          shellHook = ''
            alias hello='echo "Hello World from non-macOS!"'
          '';
        };
      });
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
