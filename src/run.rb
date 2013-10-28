#!/usr/bin/ruby -w

require_relative 'lib/tmux'
require_relative 'lib/window'

# syntax sugar for layout configuration
include Window

# default window layouts
windows = {}
windows['git-cui'] = split :horizontal do
  pane
  split :vertical, 30 do
    pane "watch --no-title --color -n '0,3' git status --short -b"
    pane "watch --no-title --color -n '1' git branch"
  end
end

# load user config if exists
config_file = File.expand_path '~/.muxig.rb'
if File.exists? config_file
  proc = Proc.new {}
  eval(File.read(config_file), proc.binding)
end

# process command line arguments
command = ARGV[0]
case command
when ''
  Tmux.call ''
when 'clear-panes'
  Tmux.clear_panes
when 'close-window'
  Tmux.call 'kill-window'
when 'kill'
  Tmux.call 'kill-session'
when 'command-list'
  # internal for autocompletion
  puts 'clear-panes close-window command-list kill ' + windows.keys.join(' ')
else
  if windows[command]
    Tmux.call 'set-window-option default-path `pwd` > /dev/null'
    Tmux.make_window windows[command]
    Tmux.call 'select-pane -t 0'
  else
    puts "muxig: Command *#{command}* is unknown."
  end
end
