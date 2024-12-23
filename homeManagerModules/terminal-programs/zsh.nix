{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    byron-home.zsh.enable = lib.mkEnableOption "enable zsh";
  };

  config = lib.mkIf config.byron-home.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases =
        let
          flakeDir = "~/.config/nix-config";
        in
        {
            hms = "home-manager switch --flake ${flakeDir}";

            darwin = "nix build .#darwinConfigurations.Byrons-Mac-mini.system && ./result/sw/bin/darwin-rebuild switch --flake .#Byrons-Mac-mini";

            # Frequently used commands
            type = "type -a";
            md = "mkdir -p";
            cls = "clear";

            g = "git";
            ga = "git add";
            gaa = "git add --all";

            gb = "git branch";
            gba = "git branch --all";
            gbd = "git branch --delete";

            gcb = "git checkout -b";
            gcd = "git checkout $(git_develop_branch)";
            gcf = "git config --list";
            gcm = "git checkout $(git_main_branch)";
            gcmsg = "git commit --message";
            gco = "git checkout";
            gd = "git diff";
            ggsup = "git branch --set-upstream-to = origin/$(git_current_branch)";
            gss = "git status --short";
            gssi = "git status --short --ignored";
            gp = "git push";
            gl = "git pull";
        };

      history = {
        save = 10000;
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignoreSpace = true;
      };

      completionInit = ''
        autoload -Uz compinit && compinit
        autoload -Uz bashcompinit && bashcompinit
      '';

      initExtra = ''
        zstyle :compinstall filename "$HOME/.zshrc"

        unsetopt beep

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu select
        zstyle -e ':completion:*:default' list-colors 'reply=("''${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:''${(s.:.)LS_COLORS}")'

        autoload -Uz is-at-least

        mkdir -p ~/.zfunc
        cog generate-completions zsh > ~/.zfunc/_cog

        # Setup the brew package manager for GUI apps
        eval "$(/opt/homebrew/bin/brew shellenv)"

        function git_current_branch() {
            local ref
            ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
            local ret=$?
            if [[ $ret != 0 ]]; then
                [[ $ret == 128 ]] && return  # no git repo.
                ref=$(git rev-parse --short HEAD 2> /dev/null) || return
            fi
            echo ''${ref#refs/heads/}
        }

        function git_current_user_name() {
            __git_prompt_git config user.name 2>/dev/null
        }

        function git_current_user_email() {
            __git_prompt_git config user.email 2>/dev/null
        }

        function git_repo_name() {
            local repo_path
            if repo_path="$(git rev-parse --show-toplevel 2>/dev/null)" && [[ -n "$repo_path" ]]; then
                echo ''${repo_path:t}
            fi
        }

        function current_branch() {
            git_current_branch
        }

        function git_develop_branch() {
            command git rev-parse --git-dir &>/dev/null || return
            local branch
            for branch in dev devel develop development; do
                if command git show-ref -q --verify refs/heads/$branch; then
                    echo $branch
                    return 0
                fi
            done

            echo develop
            return 1
        }

        function git_main_branch() {
            command git rev-parse --git-dir &>/dev/null || return
            local ref
            for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,master}; do
                if command git show-ref -q --verify $ref; then
                    echo ''${ref:t}
                    return 0
                fi
            done

            echo master
            return 1
        }

        # mkcd is equivalent to takedir
        function mkcd takedir() {
            mkdir -p $@ && cd ''${@:$#}
        }

        function takeurl() {
            local data thedir
            data="$(mktemp)"
            curl -L "$1" > "$data"
            tar xf "$data"
            thedir="$(tar tf "$data" | head -n 1)"
            rm "$data"
            cd "$thedir"
        }

        function takegit() {
            git clone "$1"
            cd "$(basename ''${1%%.git})"
        }

        function take() {
            if [[ $1 =~ ^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$ ]]; then
                takeurl "$1"
            elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
                takegit "$1"
            else
                takedir "$@"
            fi
        }

        function detect-clipboard() {
            emulate -L zsh

            if [[ "''${OSTYPE}" == darwin* ]] && (( ''${+commands[pbcopy]} )) && (( ''${+commands[pbpaste]} )); then
                function clipcopy() { cat "''${1:-/dev/stdin}" | pbcopy; }
                function clippaste() { pbpaste; }
            elif [[ "''${OSTYPE}" == (cygwin|msys)* ]]; then
                function clipcopy() { cat "''${1:-/dev/stdin}" > /dev/clipboard; }
                function clippaste() { cat /dev/clipboard; }
            elif (( $+commands[clip.exe] )) && (( $+commands[powershell.exe] )); then
                function clipcopy() { cat "''${1:-/dev/stdin}" | clip.exe; }
                function clippaste() { powershell.exe -noprofile -command Get-Clipboard; }
            elif [ -n "''${WAYLAND_DISPLAY:-}" ] && (( ''${+commands[wl-copy]} )) && (( ''${+commands[wl-paste]} )); then
                function clipcopy() { cat "''${1:-/dev/stdin}" | wl-copy &>/dev/null &|; }
                function clippaste() { wl-paste --no-newline; }
            elif [ -n "''${DISPLAY:-}" ] && (( ''${+commands[xsel]} )); then
                function clipcopy() { cat "''${1:-/dev/stdin}" | xsel --clipboard --input; }
                function clippaste() { xsel --clipboard --output; }
            elif [ -n "''${DISPLAY:-}" ] && (( ''${+commands[xclip]} )); then
                function clipcopy() { cat "''${1:-/dev/stdin}" | xclip -selection clipboard -in &>/dev/null &|; }
                function clippaste() { xclip -out -selection clipboard; }
            elif (( ''${+commands[lemonade]} )); then
                function clipcopy() { cat "''${1:-/dev/stdin}" | lemonade copy; }
                function clippaste() { lemonade paste; }
            elif (( ''${+commands[doitclient]} )); then
                function clipcopy() { cat "''${1:-/dev/stdin}" | doitclient wclip; }
                function clippaste() { doitclient wclip -r; }
            elif (( ''${+commands[win32yank]} )); then
                function clipcopy() { cat "''${1:-/dev/stdin}" | win32yank -i; }
                function clippaste() { win32yank -o; }
            elif [[ $OSTYPE == linux-android* ]] && (( $+commands[termux-clipboard-set] )); then
                function clipcopy() { cat "''${1:-/dev/stdin}" | termux-clipboard-set; }
                function clippaste() { termux-clipboard-get; }
            elif [ -n "''${TMUX:-}" ] && (( ''${+commands[tmux]} )); then
                function clipcopy() { tmux load-buffer "''${1:--}"; }
                function clippaste() { tmux save-buffer -; }
            else
                function _retry_clipboard_detection_or_fail() {
                    local clipcmd="''${1}"; shift
                    if detect-clipboard; then
                        "''${clipcmd}" "$@"
                    else
                        print "''${clipcmd}: Platform $OSTYPE not supported or xclip/xsel not installed" >&2
                        return 1
                    fi
                }
                function clipcopy() { _retry_clipboard_detection_or_fail clipcopy "$@"; }
                function clippaste() { _retry_clipboard_detection_or_fail clippaste "$@"; }
                return 1
            fi
        }

        function clipcopy clippaste {
            unfunction clipcopy clippaste
            detect-clipboard || true # let one retry
            "$0" "$@"
        }


        function copypath {
            # If no argument passed, use current directory
            local file="''${1:-.}"

            # If argument is not an absolute path, prepend $PWD
            [[ $file = /* ]] || file="$PWD/$file"

            # Copy the absolute path without resolving symlinks
            # If clipcopy fails, exit the function with an error
            print -n "''${file:a}" | clipcopy || return 1

            echo ''${(%):-"%B''${file:a}%b copied to clipboard."}
        }


        function copyfile {
            emulate -L zsh
            clipcopy $1
        }
      '';
    };
  };
}