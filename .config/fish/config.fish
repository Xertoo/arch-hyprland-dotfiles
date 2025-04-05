if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_vi_cursor;
    switch $fish_bind_mode
        case default
            echo -ne '\e[2 q'  # Block cursor
        case insert
            echo -ne '\e[2 q'  # Beam cursor
        case replace_one
            echo -ne '\e[2 q'  # Underline cursor
        case visual
            echo -ne '\e[2 q'  # Block cursor
    end
end

function fish_prompt
    set_color red
    if test (id -u) -eq 0
        printf "root@"
    else
        printf "%s@" $USER
    end

    set_color normal
    printf "%s " (hostname -s)

    set_color blue
    printf "%s " (prompt_pwd)

    set_color normal
	fish_vi_key_bindings
	fish_vi_cursor
    echo -n "> "
end

alias vim='nvim'
alias nano='nvim'
alias sudo='sudo '
alias q='exit'
alias lg='lazygit'
alias pacin='sudo pacman -S'
alias pacrm='sudo pacman -R'
alias pacrma='sudo pacman -Rns'

set -x MANPAGER "nvim +Man!"

