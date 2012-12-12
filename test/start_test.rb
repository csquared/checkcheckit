require 'helper'

class StartTest < CheckCheckIt::TestCase

  def setup
    Examples.create_grocery_list(home)
  end

  def test_list_parses_steps
    console.in_stream = MiniTest::Mock.new
    6.times { console.in_stream.expect :gets, "y" }
    result = check "start groceries"
    console.in_stream.verify
  end

  def test_list_parses_commands
  end

end

