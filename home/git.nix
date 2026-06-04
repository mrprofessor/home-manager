{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    includes = [
      {
        condition = "gitdir:~/kai/**";
        contents.user.email = "rudra.kar@bidone.co.nz";
      }
    ];

    settings = {
      user = {
        name = "mrprofessor";
        email = "rudra.kar@icloud.com";
        signingKey = "~/.ssh/github_signing.pub";
      };

      gpg.format = "ssh";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      commit.gpgSign = true;
      tag.gpgSign = true;

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };
  };
}
