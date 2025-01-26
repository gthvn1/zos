let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    zig
    zls
    qemu
    llvmPackages_19.bintools
    helix
    lazygit
  ];

COLORTERM = "truecolor";
}
