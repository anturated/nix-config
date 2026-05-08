{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.ceirios;
in
{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "done"; # notify when long commands finish
        src = pkgs.fishPlugins.done;
      }
    ];

    shellInit = ''
      # source .fish_profile if present (put login-shell env vars there)
      if test -f ~/.fish_profile
          source ~/.fish_profile
      end

      # ~/.local/bin first, depot_tools last
      fish_add_path --prepend ~/.local/bin
      if test -d ~/Applications/depot_tools
          fish_add_path --append ~/Applications/depot_tools
      end

      ${lib.optionalString cfg.profiles.gaming ''
        # asdf shims
        if test -z "$ASDF_DATA_DIR"
            set _asdf_shims "$HOME/.asdf/shims"
        else
            set _asdf_shims "$ASDF_DATA_DIR/shims"
        end
        if not contains $_asdf_shims $PATH
            set -gx --prepend PATH $_asdf_shims
        end
        set --erase _asdf_shims
      ''}

      # matugen theme
      if test -f ~/.config/fish/theme.fish
          source ~/.config/fish/theme.fish
      end
    '';

    interactiveShellInit = ''
      # man pages via bat
      set -x MANROFFOPT "-c"
      set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

      # done plugin tuning
      set -U __done_min_cmd_duration 10000
      set -U __done_notification_urgency_level low

      # bang-bang shortcuts: !! repeats last command, !$ repeats last argument
      if [ "$fish_key_bindings" = fish_vi_key_bindings ]
          bind -Minsert ! __history_previous_command
          bind -Minsert '$' __history_previous_command_arguments
      else
          bind ! __history_previous_command
          bind '$' __history_previous_command_arguments
      end

      # tool integrations
      starship init fish | source
      zoxide init fish | source
      ${lib.optionalString cfg.profiles.workstation "direnv hook fish | source"}
    '';

    functions = {
      zn = {
        description = "zoxide + direnv + nvim";
        body = ''
          if test (count $argv) -eq 0
              echo "Usage: zn <directory>"
              return 1
          end

          z $argv[1]

          if test -f .envrc
              eval (direnv export fish)
          end

          nvim
        '';
      };
      fish_greeting = {
        description = "exec on start";
        body = "fastfetch";
      };

      history = {
        description = "Command history with timestamps";
        body = "builtin history --show-time='%F %T '";
      };

      backup = {
        description = "Create <file>.bak";
        argumentNames = [ "filename" ];
        body = "cp $filename $filename.bak";
      };

      copy = {
        description = "Auto cp -r if it ends with a '/'";
        body = ''
          set count (count $argv | tr -d \n)
          if test "$count" = 2; and test -d "$argv[1]"
              set from (string trim --right --chars=/ $argv[1])
              command cp -r $from $argv[2]
          else
              command cp $argv
          end
        '';
      };

      # !! — repeat last command
      __history_previous_command = {
        body = ''
          switch (commandline -t)
          case "!"
              commandline -t $history[1]; commandline -f repaint
          case "*"
              commandline -i !
          end
        '';
      };

      # !$ — repeat last argument
      __history_previous_command_arguments = {
        body = ''
          switch (commandline -t)
          case "!"
              commandline -t ""
              commandline -f history-token-search-backward
          case "*"
              commandline -i '$'
          end
        '';
      };
    };

    # aliases
    shellAliases = {
      # navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";

      # file listing — eza
      ls = "eza -al --color=always --group-directories-first --icons";
      la = "eza -a  --color=always --group-directories-first --icons";
      ll = "eza -l  --color=always --group-directories-first --icons";
      lt = "eza -aT --color=always --group-directories-first --icons";
      "l." = ''eza -a | grep -e "^\."'';

      # System
      jctl = "journalctl -p 3 -xb";

      # Archives
      tarnow = "tar -acf";
      untar = "tar -zxvf";

      # Networking
      wget = "wget -c";
      refreshwifi = "nmcli device wifi rescan";
      tb = "nc termbin.com 9999";

      # Hardware / processes
      hw = "hwinfo --short";
      psmem = "ps auxf | sort -nr -k 4";
      psmem10 = "ps auxf | sort -nr -k 4 | head -10";

      # grep / color wrappers
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      dir = "dir --color=auto";
      vdir = "vdir --color=auto";

      # Misc
      ff = "fastfetch";
      sleep-timer = "echo '  Sleep in 1 hour' && brightnessctl -d amdgpu_bl1 -q s 0% && sleep 3600 && systemctl suspend";
    };
  };
}
