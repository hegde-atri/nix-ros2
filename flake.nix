{
  description = "A very basic flake";
  inputs = {
    nix-ros-overlay.url = "github:hegde-atri/nix-ros-overlay";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
  };
  outputs = { self, nix-ros-overlay, nixpkgs }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nix-ros-overlay.overlays.default ];
        };
      in {
        devShells.default = pkgs.mkShell {
          name = "ROS2 Humble";
          packages = with pkgs.rosPackages.humble; [
            ros-core
            pkgs.colcon
            geometry-msgs
            sros2
          ];
          shellHook = ''
            alias hello='echo "Hello World!"'
          '';
        };
      });
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
