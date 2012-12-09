require 'helper'

class ListTest < CheckCheckIt::TestCase

  def setup
    Examples.create_grocery_list(home)
    @list = List.new('~/checkcheckit/personal/groceries')
  end

  def test_list_parses_steps
    @list.steps.size.must_equal 3
  end

  def test_list_parses_commands
  end

end
