
class SizeHelper
  def self.fill_absolute_sizes!(max_size, nodes)
    sum = 0
    flexible_nodes = []
    nodes.each do |node|
      sum += node.size
      raise RangeError, 'Sum exceeds window/pane size ' + max_size.to_s if sum > max_size

      node.absolute_size = node.size
      flexible_nodes.push node if node.size == Window::Node::FLEXIBLE_SIZE
    end

    if flexible_nodes.count
      part = (max_size - sum) / flexible_nodes.count
      flexible_nodes.each { |node| node.absolute_size = part }
    end
  end
end
