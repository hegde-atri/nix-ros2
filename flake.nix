{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    commonShellHook = ''
      eval "$(starship init bash)"
    '';
  in
    {
      devShell.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [ 
          hello
          starship
          eza
        ];
        shellHook = ''
          ${commonShellHook}
        '';
      };

      devShell.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.mkShell {
        buildInputs = with nixpkgs.legacyPackages.aarch64-darwin; [ 
          hello
          starship
          eza
        ];
        shellHook = ''
          echo "Detected Apple Silicon"
          ${commonShellHook}
        '';
      };
    };
}
