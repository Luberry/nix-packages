{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
  linuxPackages = pkgs.linuxPackages_6_1;
in
rec {
  i3blocks-modules = callPackage ./i3blocks-modules { };
}
