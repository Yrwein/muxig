
require 'test/unit'
require_relative '../../src/lib/window.rb'

class TestLayout < Test::Unit::TestCase
  def test_clean_window
    window = Window.pane 'clean', 'echo foo'

    assert_instance_of Window, window
    assert_equal 'clean', window.name
    assert_instance_of Window::Pane, window.root
    assert_equal 'echo foo', window.root.command
    assert_equal Window::Node::SIZE_SPREADABLE, window.root.size
  end

  def test_split_with_two_panes
    window = Window.split 'echoes', :horizontal do
      pane 'echo foo'
      pane 'echo bar', 30
    end

    assert_instance_of Window, window
    assert_equal 'echoes', window.name
    assert_instance_of Window::Split, window.root
    assert_equal :horizontal, window.root.type
    assert_equal 2, window.root.nodes.count
    assert_equal 'echo foo', window.root.nodes[0].command
    assert_equal 'echo bar', window.root.nodes[1].command
  end

  def test_split_nested
    window = Window.split 'git-cui', :horizontal do
      pane
      split :vertical, 30 do
        pane 'git watch status'
        pane 'git watch branch'
      end
    end

    assert_instance_of Window::Pane, window.root.nodes[0]
    assert_instance_of Window::Split, window.root.nodes[1]
    assert_equal 'git watch status', window.root.nodes[1].nodes[0].command
    assert_equal 'git watch branch', window.root.nodes[1].nodes[1].command
  end
end
