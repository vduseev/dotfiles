{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
      bun
      atuin
      jq
      vscode
      starship
    ];

    username = "vduseev";
    homeDirectory = "/home/vduseev";

    stateVersion = "25.05";
  };
}
