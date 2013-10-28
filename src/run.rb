#!/usr/bin/ruby -w

require_relative 'lib/tmux'

command = ARGV[0]
case command
when ""
  Tmux.call ""

when "project"
  session_name = "Git_CUI"

  Tmux.call "start-server"
  Tmux.call "set-option -g base-index 1"
  Tmux.call "new-session -d -s #{session_name} -n 'git cui'"

  # (1nd) window "git cui"
  Tmux.make_window Muxig.git_cui_window
  Tmux.call "select-pane -t 0"

  # (2nd) window home
  Tmux.call "new-window -n 'home'"
  Tmux.call "send-keys -t #{session_name}:2 'cd ~' C-m"

  Tmux.call "select-window -t #{session_name}:1"
  Tmux.call "-u attach-session"

when "git-cui"
  git_cui = Window.split 'git-cui', :horizontal do
    pane
    split :vertical, 30 do
      pane "watch --no-title --color -n '0,3' git status --short -b"
      pane "watch --no-title --color -n '1' git branch"
    end
  end

  Tmux.call "set-window-option default-path `pwd` > /dev/null"
  Tmux.make_window git_cui
  Tmux.call "select-pane -t 0"

when "clear-panes"
  Tmux.clear_panes

when "close-window"
  Tmux.call "kill-window"

when "kill"
  Tmux.call "kill-session"

else
  puts "muxig: Command *#{command}* is unknown."

end
