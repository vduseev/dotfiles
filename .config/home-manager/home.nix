{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
      bun
      atuin
      jq
      vscode
    ];

    username = "vduseev";
    homeDirectory = "/home/vduseev";

    stateVersion = "25.05";
  };
}
