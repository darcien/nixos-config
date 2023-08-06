{ pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> { };
in

{
  programs.lazygit = {
    enable = true;
    package = pkgsUnstable.lazygit;
    settings = {
      os = {
        editPreset = "vscode";
      };
      promptToReturnFromSubprocess = false;
      customCommands = [
        {
          key = "<c-p>";
          command = "git push -u {{index .PromptResponses 0}} --no-verify --force-with-lease";
          context = "files";
          description = "Push without verify and force with lease";
          prompts = [
            {
              type = "input";
              title = "Enter upstream as <remote> <branchname>";
              initialValue = "{{.SelectedRemote.Name}} {{.SelectedLocalBranch.Name}}";
            }
          ];
        }
        {
          key = "<c-a>";
          description = "Amend last commit without edit and verify";
          command = "git commit --amend --no-edit --no-verify";
          context = "files";
          subprocess = true;
        }
      ];
    };
  };
}
