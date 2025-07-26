{ stdenv, lib }:

stdenv.mkDerivation {
  pname = "grubstolfo-casual";
  version = "1.0";

  src = lib.cleanSource ./.;

  dontBuild = true;
  dontConfigure = true;
  installPhase = ''
    dst="$out/grub/themes/mytheme"
    mkdir -p "$dst"
    cp -r ./* "$dst"
  '';

  meta = with lib; {
    description = "astolfo casual theme for GRUB";
    license = licenses.free; # adjust as needed
    platforms = platforms.linux;
  };
}
