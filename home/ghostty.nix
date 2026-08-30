{ config, pkgs, ... }:

{
  xdg.configFile."ghostty/config".source = ./ghostty/config;
}
