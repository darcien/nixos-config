{
  programs.git = {
    enable = true;

    userName = "Yosua Ian Sebastian";
    userEmail = "git@darcien.me";


    extraConfig = {
      pull.rebase = true;

      merge.conflictstyle = "zdiff3";

      core.editor = "micro";
    };

    aliases = {
      co = "checkout";

      s = "status -s";

      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
      lgt = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --tags";

      pure = "pull upstream master --rebase";
    };
  };
}
