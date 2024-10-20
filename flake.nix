{
  description = "Rust Development Overlay";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
 };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [  ];
        pkgs = import nixpkgs {
          inherit overlays system;
        };
 
        buildInputs = with pkgs; [
          openssl

          # rust
          cargo
          rustc

          gnuplot
        ];

        nativeBuildInputs = with pkgs; [ pkg-config fd cmake git ];
      in
        {
          devShell = pkgs.mkShell.override { stdenv = pkgs.llvmPackages_19.stdenv; } {
            buildInputs = buildInputs ++ [ pkgs.rust-analyzer pkgs.rustfmt pkgs.clippy ];
            nativeBuildInputs = nativeBuildInputs;
          };
        }
    );
}
