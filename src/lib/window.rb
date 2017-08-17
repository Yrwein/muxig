
module Window
  def pane(new_command = nil)
    Pane.new new_command, Node::FLEXIBLE_SIZE
  end

  def split(split_type, &block)
    split = Split.new split_type, Node::FLEXIBLE_SIZE
    split.instance_eval(&block)
    split
  end

  class Node
    FLEXIBLE_SIZE = 0

    attr_reader :size
    attr_reader :commands
    attr_accessor :absolute_size

    def initialize(size)
      @size = size
      @commands = []
    end

    def command(new_command)
      @commands.push new_command if new_command
    end
  end

  class Pane < Node
    def initialize(new_command, size)
      super size
      command new_command
    end
  end

  class Split < Node
    TYPE_VERTICAL = :vertical
    TYPE_HORIZONTAL = :horizontal

    attr_reader :nodes, :type

    def initialize(type, size)
      super size
      @type = type
      @nodes = []
    end

    def pane(new_command = nil, size = Node::FLEXIBLE_SIZE)
      @nodes.push Pane.new new_command, size
    end

    def split(type, size = Node::FLEXIBLE_SIZE, &block)
      split = Split.new type, size
      split.instance_eval(&block)

      @nodes.push split
    end
  end
end
