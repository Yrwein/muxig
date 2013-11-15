
require_relative 'window';

module Tmux
  # Calls system tmux command and returns stripped output
  def self.call(options)
    ` tmux #{options}`.strip!
  end

  # Executes system command in current pane
  def self.run(command)
    # f. e. command:
    #    watch --no-title --color -n '1' git branch
    # -> send-keys 'watch --no-title --color -n '''1''' git branch' C-m
    Tmux.call "send-keys ' " + command.sub(/'/, "'''") + "' C-m"
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
        node.nodes.each_with_index do |child_node, i|
          if i != 0
            Tmux.call node.type == :horizontal ? 'splitw -h' : 'splitw -v'
            Tmux.call 'last-pane'
            resize_active_pane node.nodes[0].size, node.type unless node.nodes[0].size == Window::Node::FLEXIBLE_SIZE
            Tmux.call 'last-pane'
          end

          if i == node.nodes.size - 1
            resize_active_pane child_node.absolute_size, node.type  unless child_node.size == Window::Node::FLEXIBLE_SIZE
          end
          create_window_node child_node
        end
      end
    end

    def resize_active_pane(new_size, type)
      pane = Tmux.call "list-panes | grep active | cut -d: -f1"
      if type == :horizontal
        Tmux.call "resize-pane -t #{pane} -x #{new_size}"
      else
        Tmux.call "resize-pane -t #{pane} -y #{new_size}"
      end
    end
  end
end
