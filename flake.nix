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
        packages.grub-theme-mytheme = pkgs.stdenv.mkDerivation {
          pname = "grub-theme-mytheme";
          version = "0.1";
          src = pkgs.lib.cleanSource ./.;

          dontBuild = true;
          installPhase = ''
            dst="$out/share/grub/themes/mytheme"
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
        packages.default = self.packages.${system}.grub-theme-mytheme;
      };

      flake = {
        overlays.default = final: prev: {
          grub-theme-mytheme = self.packages.${prev.system}.grub-theme-mytheme;
        };
      };
    };
}
