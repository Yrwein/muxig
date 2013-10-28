#!/usr/bin/env ruby

def tmux(options)
  `tmux #{options}`.strip!
end

def muxig_git_cui()
  tmux "splitw"
  tmux "send-keys 'watch --no-title --color -n '''0,3''' git status --short -b' C-m"
  tmux "splitw"
  tmux "send-keys 'watch --no-title --color -n '''1''' git branch' C-m"
  tmux "select-layout main-vertical > /dev/null"
  tmux "select-pane -t 0"
  muxig_set_pane_width 1, 30
end

def muxig_clear_panes()
  if tmux("list-panes | wc -l") != "1"
    target = tmux "list-panes | grep active | cut -d: -f1"
    tmux "kill-pane -a -t #{target}"
  end
end

def muxig_set_pane_width(pane, new_width)
  pane_width = tmux "list-panes | grep $pane: | cut -dx -f1 | cut -d[ -f2"
  resize_to = pane_width.to_i - new_width.to_i

  if resize_to > 0
    tmux "resize-pane -t #{pane} -R #{resize_to}"
  else
    tmux "resize-pane -t #{pane} -L #{resize_to.abs}"
  end
end

command = ARGV[0]
case command
when ""
  tmux ""

when "project"
  session_name = "Git_CUI"

  tmux "start-server"
  tmux "set-option -g base-index 1"
  tmux "new-session -d -s #{session_name} -n 'git cui'"

  # (1nd) window "git cui"
  muxig_git_cui

  # (2nd) window home
  tmux "new-window -n 'home'"
  tmux "send-keys -t #{session_name}:2 'cd ~' C-m"

  tmux "select-window -t #{session_name}:1"
  tmux "-u attach-session"

when "git-cui"
  tmux "set-window-option default-path `pwd` > /dev/null"
  muxig_clear_panes
  muxig_git_cui

when "clear-panes"
  muxig_clear_panes

when "close-window"
  tmux "kill-window"

when "kill"
  tmux "kill-session"

else
  echo "muxig: Command *#{command}* is unknown."

end
