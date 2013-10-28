
require 'test/unit'
require_relative '../../src/lib/window.rb'

include Window

class TestLayout < Test::Unit::TestCase
  def test_clean_window
    node = Window.pane 'echo foo'

    assert_instance_of Window::Pane, node
    assert_equal 'echo foo', node.command
    assert_equal Window::Node::SIZE_SPREADABLE, node.size
  end

  def test_split_with_two_panes
    node = Window.split :horizontal do
      pane 'echo foo'
      pane 'echo bar', 30
    end

    assert_instance_of Window::Split, node
    assert_equal :horizontal, node.type
    assert_equal 2, node.nodes.count
    assert_equal 'echo foo', node.nodes[0].command
    assert_equal 'echo bar', node.nodes[1].command
  end

  def test_split_nested
    node = Window.split :horizontal do
      pane
      split :vertical, 30 do
        pane 'git watch status'
        pane 'git watch branch'
      end
    end

    assert_instance_of Window::Pane, node.nodes[0]
    assert_instance_of Window::Split, node.nodes[1]
    assert_equal 'git watch status', node.nodes[1].nodes[0].command
    assert_equal 'git watch branch', node.nodes[1].nodes[1].command
  end
end
