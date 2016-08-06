
require_relative 'window';
require_relative 'size_helper';

module Tmux
  # Calls system tmux command and returns stripped output
  def self.call(options)
    result = ` tmux #{options}`.strip!
  end

  # Executes system command in current pane
  def self.run(command)
    # f. e. command:
    #    watch --no-title --color -n '1' git branch
    # -> send-keys 'watch --no-title --color -n '''1''' git branch' C-m
    pane = Tmux.call "list-panes | grep active | cut -d: -f1"
    Tmux.call "send-keys -t #{pane} ' " + command.sub(/'/, "'''") + "' C-m"
  end

  def self.clear_panes
    if Tmux.call("list-panes | wc -l") != "1"
      target = Tmux.call "list-panes | grep active | cut -d: -f1" # TODO better
      Tmux.call "kill-pane -a -t #{target}"
    end
  end

  class WindowBuilder
    def initialize(default_path)
      @default_path = default_path
    end

    def make_window(window)
      Tmux.clear_panes
      create_window_node window
      Tmux.call 'select-pane -t 0'
    end

    def create_window_node(node)
      if node.kind_of? Window::Pane
        Tmux.run "cd #{@default_path}"
      end

      node.commands.each { |c| Tmux.run c }

      if node.kind_of? Window::Split
        max_size = get_size node.type
        SizeHelper.fill_absolute_sizes! max_size, node.nodes
        node.nodes.each_with_index do |child_node, i|
          if i != 0
            pane = Tmux.call "list-panes | grep active | cut -d: -f1"
            Tmux.call node.type == :horizontal ? "splitw -h -t #{pane}" : "splitw -v -t #{pane}"
            Tmux.call 'last-pane'
            resize_active_pane node.nodes[0].absolute_size, node.type
            Tmux.call 'last-pane'
          end

          if i == node.nodes.size - 1
            resize_active_pane child_node.absolute_size, node.type
          end
          create_window_node child_node
        end
      end
    end

    # Resizes pane to specified width (type horizontal) / height of the current pane
    def resize_active_pane(new_size, type)
      pane = Tmux.call "list-panes | grep active | cut -d: -f1"
      if type == :horizontal
        Tmux.call "resize-pane -t #{pane} -x #{new_size}"
      else
        Tmux.call "resize-pane -t #{pane} -y #{new_size}"
      end
    end

    # Returns width (type horizontal) / height of the current pane
    def get_size(type)
      if type == :horizontal
        pane_size = Tmux.call "list-panes | grep active | cut -dx -f1 | cut -d[ -f2"
      else
        pane_size = Tmux.call "list-panes | grep active | cut -dx -f2 | cut -d] -f1"
      end
      pane_size.to_i
    end
  end
end
