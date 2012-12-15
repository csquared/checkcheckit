require 'helper'

class ListTest < CheckCheckIt::TestCase

  def setup
    super
    Examples.create_grocery_list(home)
    @list = List.new('~/checkcheckit/personal/groceries')
  end

  def test_list_parses_steps
    @list.steps.size.must_equal 3
  end


  def test_to_json
    @list.to_h.must_equal({
      name: 'groceries',
      steps: [
        { name: 'pineapple', body: '' },
        { name: 'mangoes', body: " enhance the flavor with \n spice\n" },
        { name: 'fudge', body: ' best from a place in sutter creek'}
      ]
    })
  end
end
