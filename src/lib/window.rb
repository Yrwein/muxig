
module Window
  def pane(command = nil)
    Pane.new command, Node::SIZE_SPREADABLE
  end

  def split(split_type, &block)
    split = Split.new split_type, Node::SIZE_SPREADABLE
    split.instance_eval(&block)
    split
  end

  class Node
    SIZE_SPREADABLE = 0

    attr_reader :size

    def initialize(size)
      @size = size
    end
  end

  class Pane < Node
    attr_reader :command

    def initialize(command, size)
      super size
      @command = command
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

    def pane(command = nil, size = Node::SIZE_SPREADABLE)
      @nodes.push Pane.new command, size
    end

    def split(type, size = Node.SIZE_SPREADABLE, &block)
      split = Split.new type, size
      split.instance_eval(&block)

      @nodes.push split
    end
  end
end
