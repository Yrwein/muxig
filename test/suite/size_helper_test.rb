
require 'test/unit'
require_relative '../../src/lib/size_helper.rb'
require_relative '../../src/lib/window.rb'

class TestSizeHelper < Test::Unit::TestCase
  def test_two_panes__first_abs_second_flex
    nodes = [ Window::Pane.new(nil, 10), Window::Pane.new(nil, Window::Node::FLEXIBLE_SIZE) ]
    SizeHelper.fill_absolute_sizes! 100, nodes
    assert_equal 10, nodes[0].absolute_size
    assert_equal 90, nodes[1].absolute_size
  end

  def test_two_panes__first_flex_second_flex
    nodes = [ Window::Pane.new(nil, Window::Node::FLEXIBLE_SIZE), Window::Pane.new(nil, Window::Node::FLEXIBLE_SIZE) ]
    SizeHelper.fill_absolute_sizes! 100, nodes
    assert_equal 50, nodes[0].absolute_size
    assert_equal 50, nodes[1].absolute_size
  end

  def test_sum_size_greater_than_max_size_should_raise_error
    nodes = [ Window::Pane.new(nil, 10), Window::Pane.new(nil, 30) ]
    error = assert_raise RangeError do
      SizeHelper.fill_absolute_sizes! 20, nodes
    end
    assert_equal 'Sum exceeds window/pane size 20', error.message
  end
end
