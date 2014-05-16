require "minitest"

class BasicTest < MiniTest::Test
  def test_true
    assert true
  end

  def test_false
    refute false
  end

  def test_long
    sleep 0.2
    assert true
  end

  def test_failing
    assert false
  end
end
