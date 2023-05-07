{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = { url = "github:hercules-ci/flake-parts"; inputs.nixpkgs-lib.follows = "nixpkgs"; };
    src = { url = "https://github.com/nomic-ai/gpt4all-chat"; flake = false; submodules = true; type = "git"; };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { pkgs, config, ... }: {
        packages = {
          gpt4all-chat = pkgs.qt6Packages.callPackage ./. {
            inherit (inputs) src;
            version = builtins.concatStringsSep "-" (builtins.match "([0-9]{4})([0-9]{2})([0-9]{2})[0-9]*" inputs.src.lastModifiedDate);
          };
          default = config.packages.gpt4all-chat;
        };
      };
    };
}
