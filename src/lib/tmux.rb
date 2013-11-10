
require_relative 'window';

module Tmux
  # Calls system tmux command and returns stripped output
  def self.call(options)
    `tmux #{options}`.strip!
  end

  # Executes system command in current pane
  def self.run(command)
    # f. e. command:
    #    watch --no-title --color -n '1' git branch
    # -> send-keys 'watch --no-title --color -n '''1''' git branch' C-m
    Tmux.call "send-keys '" + command.sub(/'/, "'''") + "' C-m"
  end

  def self.make_window(window)
    clear_panes
    create_window_node window
  end

  def self.clear_panes
    if Tmux.call("list-panes | wc -l") != "1"
      target = Tmux.call "list-panes | grep active | cut -d: -f1" # TODO better
      Tmux.call "kill-pane -a -t #{target}"
    end
  end

  def self.create_window_node(node)
    node.commands.each { |c| run c }

    if node.kind_of? Window::Split
      split_pane = false
      node.nodes.each do |child_node|
        if split_pane
          Tmux.call node.type == :horizontal ? 'splitw -h' : 'splitw -v'
        end
        resize_active_pane child_node.size, node.type unless child_node.size == Window::Node::SIZE_SPREADABLE
        create_window_node child_node
        split_pane = true
      end
    end
  end

  def self.resize_active_pane(new_size, type)
    # TODO refactor
    pane = Tmux.call "list-panes | grep active | cut -d: -f1"
    if type == :horizontal
      pane_size = Tmux.call "list-panes | grep active | cut -dx -f1 | cut -d[ -f2"
    else
      pane_size = Tmux.call "list-panes | grep active | cut -dx -f2 | cut -d] -f1"
    end
    resize_to = pane_size.to_i - new_size.to_i

    if type == :horizontal
      if resize_to > 0
        Tmux.call "resize-pane -t #{pane} -R #{resize_to}"
      else
        Tmux.call "resize-pane -t #{pane} -L #{resize_to.abs}"
      end
    else
      if resize_to > 0
        Tmux.call "resize-pane -t #{pane} -D #{resize_to}"
      else
        Tmux.call "resize-pane -t #{pane} -U #{resize_to.abs}"
      end
    end
  end
end
