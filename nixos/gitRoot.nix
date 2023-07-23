{
  programs.git = {
    enable = true;

    # This has different record shape compared to git.nix
    # as this options is from nixpkgs
    # while the regular user one is from home manager.

    config = {
      user.name = "Yosua Ian Sebastian";
      user.email = "git@darcien.me";

      pull.rebase = true;
      merge.conflictstyle = "zdiff3";

      safe.directory = [
        "home/darcien/projects/pelorperak/"
      ];
    };

  };
}
