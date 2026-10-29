# --- T:X11 fix ---
set -x DISPLAY :0
set -e WAYLAND_DISPLAY
set -x LIBGL_ALWAYS_SOFTWARE 1

if status is-interactive
    # starship prompt
    starship init fish | source

    # better ls
    if command -v eza >/dev/null
        alias ls='eza --icons --group-directories-first'
    end

    alias ldd="/usr/lib/ld-musl-aarch64.so.1"

    # git abbrs
    abbr lg lazygit
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'

    # ls
    abbr l ls
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la'
    abbr llh 'ls -lh'

    # fastfetch
    abbr ff fastfetch
end

set -gx LANG en_US.UTF-8
set fish_greeting ""

# opencode
fish_add_path /home/elliot/.opencode/bin
fish_add_path $HOME/.local/bin

# opencode
# fish_add_path /home/elliot/.opencode/bin
# export PATH="$HOME/.local/bin:$PATH"
