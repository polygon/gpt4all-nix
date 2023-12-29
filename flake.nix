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
      gpt4all-chat-2_5_4 = 
      let
        version = "2.5.4";
      in
      pkgs.qt6Packages.callPackage ./gpt4all-chat.nix {
        src = pkgs.fetchFromGitHub {
          owner = "nomic-ai";
          repo = "gpt4all";
          rev = "v${version}";
          fetchSubmodules = true;
          sha256 = "sha256-JZ8O9a0XRwRR81b+A97sWOtiL0M12cqLh9eoE+VkDVg=";
        };
        inherit version;
      };
      gpt4all-chat-avx-2_5_4 = self.packages.${system}.gpt4all-chat-2_5_4.override { withAvx2 = false; };
      gpt4all-chat-nightly = pkgs.qt6Packages.callPackage ./gpt4all-chat.nix { src=gpt4all; };
      gpt4all-chat-avx-nightly = self.packages.${system}.gpt4all-chat-nightly.override { withAvx2 = false; };
      gpt4all-chat = self.packages.${system}.gpt4all-chat-2_5_4;
      gpt4all-chat-avx = self.packages.${system}.gpt4all-chat-avx-2_5_4;
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
