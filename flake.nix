{
  description = "A very basic flake";
  inputs = {
    nix-ros-overlay.url = "github:etherswangel/nix-ros-overlay";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
    nixgl.url = "github:nix-community/nixGL";
  };
  outputs = { nixpkgs, ... } @ inputs:
    inputs.nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ inputs.nix-ros-overlay.overlays.default inputs.nixgl.overlay ];
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
                example-interfaces
                ament-cmake-core
                turtlesim
              ];
            })
          ];
          shellHook = ''
            alias hello='echo "Hello World from macOS!"'
            alias build='colcon build --symlink-install'
          '';
        };
      } else {
        devShell = pkgs.mkShell {
          packages = [
            pkgs.colcon
            pkgs.nixgl.auto.nixGLDefault
            pkgs.libsForQt5.qt5.qtwayland
            # pkgs.python311Packages.anyqt
            (with pkgs.rosPackages.humble; buildEnv {
              paths = [
                ros-core
                geometry-msgs
                example-interfaces
                ament-cmake-core
                rqt
                rqt-graph
                rviz2
                gazebo
                turtlesim
              ];
            })
          ];
          shellHook = ''
            if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
              export QT_QPA_PLATFORM=xcb
            fi
            alias hello='echo "Hello World from non-macOS!"'
            alias gazebo='nixGL gazebo'
            alias rviz2='nixGL rviz2'
            alias build='colcon build --symlink-install'
          '';
        };
      });
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
