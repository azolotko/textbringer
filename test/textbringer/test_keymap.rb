require_relative "../test_helper"

class TestKeymap < Test::Unit::TestCase
  include Textbringer

  def test_lookup
    keymap = Keymap.new
    keymap.define_key("a", :a)
    keymap.define_key("\C-f", :c_f)
    keymap.define_key("\C-x\C-s", :c_x_c_s)
    keymap.define_key(:right, :right)
    assert_raise(ArgumentError) do
      keymap.define_key([], :foo)
    end
    assert_raise(TypeError) do
      keymap.define_key({}, :foo)
    end

    assert_equal(:a, keymap.lookup([?a.ord]))
    assert_equal(:c_f, keymap.lookup([?\C-f.ord]))
    assert_equal(:c_x_c_s, keymap.lookup([?\C-x.ord, ?\C-s.ord]))
    assert_equal(:right, keymap.lookup([:right]))
    assert_equal(nil, keymap.lookup([?x.ord]))
    assert_equal(nil, keymap.lookup([?\C-x.ord, ?s.ord]))
    assert_raise(ArgumentError) do
      keymap.lookup([])
    end
  end

  def test_global_map
    assert_equal(:self_insert, GLOBAL_MAP.lookup([?a.ord]))
    assert_equal(:self_insert, GLOBAL_MAP.lookup([?あ.ord]))
    assert_equal(nil, GLOBAL_MAP.lookup([10000000]))
    assert_equal(nil, GLOBAL_MAP.lookup([?\C-c.ord]))
    assert_equal(nil, GLOBAL_MAP.lookup([:foo]))
  end
end
