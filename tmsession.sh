tmux start-server
#tmux new-session -d -s X -n home -c ~
#tmux new-window -t X -n code -c ~/code/ish
tmux new-session -d -s X -n code -c ~/code/ish
tmux new-window -t X -n nvim -c ~/code/ish nvim
tmux attach
