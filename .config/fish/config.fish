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
    if test (id -u) -eq 0
		set_color normal
        printf "[" $USER
		set_color red
        printf "root"
		set_color normal
        printf "@" $USER
    else
		set_color normal
        printf "[" $USER
		set_color blue
        printf "%s" $USER
		set_color normal
        printf "@" $USER
    end

    set_color yellow
    printf "%s" (hostname -s)
    set_color normal
    printf "]" (hostname -s)

    set_color red
    printf "["
    printf "%s" (prompt_pwd)
    printf "]"

    set_color normal
	fish_vi_key_bindings
	fish_vi_cursor
    echo -n "\$ "
end

alias vim='nvim'
alias nano='nvim'
alias doas='doas '
alias q='exit'
alias lg='lazygit'
alias reboot='doas reboot'
alias poweroff='doas poweroff'

set -x MANPAGER "nvim +Man!"
set -x NPM_CONFIG_PREFIX $HOME/.local
set -x PATH $HOME/go/bin $HOME/.local/bin $NPM_CONFIG_PREFIX/bin $PATH
set -gx PATH $HOME/bin $PATH


#cd ~
function fish_greeting; end
export PATH="$HOME/.cargo/bin:$PATH"
