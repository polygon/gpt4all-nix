{
  description = "GPT4ALL flake";

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
      gpt4all-chat-2_6_2 = 
      let
        version = "2.6.2";
      in
      pkgs.qt6Packages.callPackage ./gpt4all-chat.nix {
        src = pkgs.fetchFromGitHub {
          owner = "nomic-ai";
          repo = "gpt4all";
          rev = "v${version}";
          fetchSubmodules = true;
          sha256 = "sha256-BQE4UQEOOUAh0uGwQf7Q9D30s+aoGFyyMH6EI/WVIkc=";
        };
        inherit version;
      };
      gpt4all-chat-avx-2_6_2 = self.packages.${system}.gpt4all-chat-2_6_2.override { withAvx2 = false; };
      gpt4all-chat-nightly = pkgs.qt6Packages.callPackage ./gpt4all-chat.nix { src=gpt4all; };
      gpt4all-chat-avx-nightly = self.packages.${system}.gpt4all-chat-nightly.override { withAvx2 = false; };
      gpt4all-chat = self.packages.${system}.gpt4all-chat-2_6_2;
      gpt4all-chat-avx = self.packages.${system}.gpt4all-chat-avx-2_6_2;
      default = self.packages.${system}.gpt4all-chat;
    };

    apps.${system} = {
      gpt4all-chat-avx = {
        type = "app";
        program = "${self.packages.${system}.gpt4all-chat-avx}/bin/chat";
      };

      default = {
        type = "app";
        program = "${self.packages.${system}.gpt4all-chat}/bin/chat";
      };
    };
  };
}
