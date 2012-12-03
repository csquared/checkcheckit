require 'helper'

class ConsoleTest < CheckCheckIt::TestCase
  def setup
    super
    dir = File.join(home, 'personal')
    FileUtils.mkdir_p(dir)
    File.open(File.join(dir, 'groceries'), 'w') do |file|
      file << "- pineapple \n - mangoes \n - fudge"
    end
  end

  def test_lists_orgs_and_lists
    check "list"
    assert_match(/^# Checklists\n/, output)
    assert_match(/^personal\n/,     output)
    assert_match(/^  groceries\n/,  output)
  end

  def test_configurable_list_dir
    dir = File.join('/foo', 'personal')
    FileUtils.mkdir_p(dir)

    @console = CheckCheckIt::Console.new(:dir => '/foo', out_stream: StringIO.new)

    check "list"
    assert_match(/^personal\n/,     output)
  end
end

