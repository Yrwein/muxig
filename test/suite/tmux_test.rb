
require_relative '../../src/lib/tmux.rb'

include Tmux

class TestTmux < Test::Unit::TestCase

  [
    ['2a93', '168x40,0,0{84x40,0,0,0,83x40,85,0,1}'],
    ['80a0', '168x40,0,0{42x40,0,0,0,41x40,43,0,2,83x40,85,0,1}'],
    ['2e66', '168x40,0,0{84x40,0,0,0,41x40,85,0,1,41x40,127,0,3}'],
    ['06bc', '168x40,0,0{42x40,0,0,0,41x40,43,0,4,41x40,85,0,1,41x40,127,0,3}'],
  ].each do |sum, layout|
    test "test_layout_checksum #{layout}" do
      assert_equal sum, Tmux.layout_checksum(layout)
    end
  end

end
