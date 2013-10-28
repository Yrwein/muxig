#!/usr/bin/ruby -w

require_relative 'lib/tmux'

command = ARGV[0]
case command
when ""
  Tmux.call ""

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
