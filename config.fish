set fish_greeting ""

function mcprep
  z mc; ty;
end

set -gx TERM xterm-256color

#fish_vi_key_bindings
fish_default_key_bindings
#set -g fish_escape_delay_ms 11

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always
export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

#set -Ua fish_user_paths $HOME/.cargo/bin

# extra commands
#stty discard undef

# maps
bind \cn 'echo \e\]1337\;ClearScrollback\x7; clear; commandline -f repaint'

# aliases
alias sm "smartctl -a /dev/disk0 | less"
alias em "emacsclient --create-frame --alternate-editor="""
alias ls "ls -p -G"
alias la "ls -A"
alias nb "newsboat"
alias ll "ls -l"
alias lla "ll -A"
alias cl "clear"
alias ty "tmux"
alias ta "tmux attach -d -t"
alias ap "afplay"
alias zr "zathura"
alias g git
command -qv nvim && alias vim nvim

set -gx EDITOR vi

set -gx PATH /opt/homebrew/bin $PATH 
# NodeJS
#set -gx PATH node_modules/.bin $PATH