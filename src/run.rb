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
when 'layout'
  layout = ARGV[1]
  layout_def = Tmux.layout_checksum(layout) + ',' + layout
  puts "tmux select-layout \"#{layout_def}\""
  Tmux.call "select-layout \"#{layout_def}\""
when 'clear-panes'
  Tmux.clear_panes
when 'close-window'
  ` tmux list-panes -F "\#{pane_pid}" | xargs kill -9`
when 'kill'
  ` tmux list-panes -s -F "\#{pane_pid}" | xargs kill -9`
when 'command-list'
  # internal for autocompletion
  puts 'clear-panes close-window command-list kill layout layout-def ' + windows.keys.join(' ')
else
  if windows[command]
    builder = Tmux::WindowBuilder.new `pwd`.strip!
    builder.make_window windows[command]
  else
    puts "muxig: Command *#{command}* is unknown."
  end
end
