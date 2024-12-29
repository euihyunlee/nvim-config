{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  languages.lua.enable = true;

  packages = with pkgs; [
    git
    stylua
  ];

  enterShell = ''
    lua -v
  '';
}
