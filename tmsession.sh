SESSION=X
tmux start-server
#tmux new-session -d -s ${SESSION} -n home -c ~
#tmux new-window -t ${SESSION} -n code -c ~/code/ish
tmux new-session -d -s ${SESSION} -n code -c ~/code/ish
tmux new-window -t ${SESSION} -n nvim -c ~/code/ish nvim -p ${1:+$(ack -g "${*// /|}" ~)}
tmux select-window -t ${SESSION}:0
tmux attach
