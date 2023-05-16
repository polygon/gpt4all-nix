{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.gpt4all = {
    url = "https://github.com/nomic-ai/gpt4all";
    flake = false;
    submodules = true;
    type = "git";
  };

  outputs = { self, nixpkgs, gpt4all }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    packages.${system} = {
      gpt4all-chat = pkgs.qt6Packages.callPackage ./gpt4all-chat.nix { src=gpt4all; };
      gpt4all-chat-avx = pkgs.qt6Packages.callPackage ./gpt4all-chat.nix { src=gpt4all; withAvx2 = false; };
      default = self.packages.${system}.gpt4all-chat;
    };

    apps.${system}.gpt4all-chat-avx = {
      type = "app";
      program = "${self.packages.${system}.gpt4all-chat-avx}/bin/chat";
    };

    apps.${system}.default = {
      type = "app";
      program = "${self.packages.${system}.gpt4all-chat}/bin/chat";
    };
  };
}
