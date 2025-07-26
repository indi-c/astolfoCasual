{
  description = "My GRUB theme as a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { pkgs, system, ... }: {
        packages.grubstolfoCasual = pkgs.stdenv.mkDerivation {
          pname = "grubstolfoCasual";
          version = "0.1";
          src = pkgs.lib.cleanSource ./.;

          dontBuild = true;
          installPhase = ''
            dst="$out/share/grub/themes/astolfoCasual"
            mkdir -p "$dst"
            cp -r ./* "$dst"
          '';

          meta = with pkgs.lib; {
            description = "A custom GRUB theme";
            platforms = platforms.linux;
            license = licenses.unlicense; # change if needed
          };
        };

        # Set default package to our theme
        packages.default = self.packages.${system}.grubstolfoCasual;
      };

      flake = {
        overlays.default = final: prev: {
          grubstolfoCasual = self.packages.${prev.system}.grubstolfoCasual;
        };
      };
    };
}
