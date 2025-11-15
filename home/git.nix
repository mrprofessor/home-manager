{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "mrprofessor";  # Change this to your name
    userEmail = "rudra.kar@icloud.com";  # Change this to your email

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
  };
}
