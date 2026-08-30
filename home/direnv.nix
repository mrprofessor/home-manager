{ config, pkgs, inputs, ... }:

{
  imports = [ inputs.direnv-instant.homeModules.direnv-instant ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = false;   # direnv-instant provides its own hook
    nix-direnv.enable = true;
    config = {
      whitelist.prefix = [ "/Users/prof/kai" ];
    };
  };

  programs.direnv-instant.enable = true;
}
