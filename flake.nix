{
  description = "gccemacs for darwin";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    emacs-nativecomp = {
      url = "github:emacs-mirror/emacs";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, emacs-nativecomp, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        overlay = import ./emacs.nix emacs-nativecomp;
        pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
      in {
        inherit overlay pkgs;
        packages = pkgs;
      });
}
