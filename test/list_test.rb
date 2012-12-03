require 'helper'

class ListTest < CheckCheckIt::TestCase

  def setup
    dir = File.join(home, 'personal')
    FileUtils.mkdir_p(dir)
    File.open(File.join(dir, 'groceries'), 'w') do |file|
      file << "- pineapple \n- mangoes \n `say mango` \n- fudge"
    end
    @list = List.new('~/checkcheckit/personal/groceries')
  end

  def test_list_parses_steps
    @list.steps.size.must_equal 3
  end

  def test_list_parses_commands
  end

end
