{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = {
      p = "cd ~/projects";
      update = "sudo nixos-rebuild switch";
      garbage = "nix-collect-garbage -d";
    };

    history = {
      size = 10000;
    };

    localVariables = {
      LANG = "en_US.UTF-8";
      CLICOLOR = 1;
      EDITOR = "code";
      VISUAL = "code";
      TERM = "xterm-256color";
    };

    initExtra = ''
      # Cycle through history based on characters already typed on the line
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      # Raw input doesn't work on NixOS
      # see Zsh-autocomplete not working in
      # https://nixos.wiki/wiki/Zsh
      # bindkey "^[[A" up-line-or-beginning-search
      # bindkey "^[[B" down-line-or-beginning-search
      bindkey "''${key[Up]}" up-line-or-beginning-search
      bindkey "''${key[Down]}" down-line-or-beginning-search

      # Make selection visible and allow using arrow keys to select
      # Need compinit to works
      zstyle ':completion:*' menu select
    '';
  };
}
