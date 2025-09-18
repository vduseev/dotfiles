{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      # Test
      hello
      
      # Shell
      atuin
      starship

      # CLI tools
      jq
      gh
      awscli
      ffmpeg
      terraform
      zola
      yt-dlp
      tree
      restic
      rustic
      
      # Languages
      uv
      bun
      rustup
      flutter
      postgresql
      d2

      # Coding
      vscode
      claude-code
      codex
      codegrab
    ];

    username = "vduseev";
    homeDirectory = "/home/vduseev";

    stateVersion = "25.05";
  };
}
