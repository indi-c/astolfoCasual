{
  description = "GRUB theme";

  outputs = { self, nixpkgs }: let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system:
      f (import nixpkgs { inherit system; }));
  in {
    packages = forAllSystems (pkgs:
      pkgs.callPackage ({ stdenv, lib }: stdenv.mkDerivation {
        pname = "grubstolfo-casual";
        version = "1.0";
        src = lib.cleanSource ./.;
        dontBuild = true;
        installPhase = ''
          dst="$out/share/grub/themes/mytheme"
          mkdir -p "$dst"
          cp -r ./* "$dst"
        '';
        meta.platforms = lib.platforms.linux;
      }) {});
    defaultPackage = forAllSystems (pkgs: self.packages.${pkgs.system});
    packages.default = self.defaultPackage;
  };
}