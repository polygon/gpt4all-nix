{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.gpt4all-chat = {
    url = "https://github.com/nomic-ai/gpt4all-chat";
    flake = false;
    submodules = true;
    type = "git";
  };

  outputs = { self, nixpkgs, gpt4all-chat }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    packages.${system} = {
      gpt4all-chat = pkgs.qt6Packages.callPackage ./gpt4all-chat.nix { src=gpt4all-chat; };
      default = self.packages.${system}.gpt4all-chat;
    };

    apps.${system}.default = {
      type = "app";
      program = "${self.packages.${system}.gpt4all-chat}/bin/chat";
    };
  };
}
