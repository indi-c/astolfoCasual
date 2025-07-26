{
  description = "GRUB theme flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # or your channel
  };

  outputs = { self, nixpkgs }: 
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f:
        builtins.listToAttrs (map (system: { name = system; value = f system; }) systems);
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.stdenv.mkDerivation {
          pname = "grub-theme-mytheme";
          version = "0.1";
          src = pkgs.lib.cleanSource ./.;

          dontBuild = true;
          installPhase = ''
            dst="$out/share/grub/themes/mytheme"
            mkdir -p "$dst"
            cp -r ./* "$dst"
          '';

          meta = {
            description = "My GRUB theme";
            platforms = pkgs.lib.platforms.linux;
            license = pkgs.lib.licenses.unfreeRedistributable; # or your license
          };
        }
      );

      defaultPackage = forAllSystems (system: self.packages.${system});
    };
}
