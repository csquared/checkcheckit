require 'helper'

class ConsoleTest < CheckCheckIt::TestCase
  def setup
    super
  end

  def test_lists_orgs_and_lists
    Examples.create_grocery_list(home)
    check "list"
    assert_match(/^# Checklists\n/, output)
    assert_match(/^personal\n/,     output)
    assert_match(/^  groceries\n/,  output)
  end

  def test_configurable_list_dir
    dir = File.join('/foo', 'personal')
    FileUtils.mkdir_p(dir)

    check "list --home /foo"
    assert_match(/^personal\n/,     output)
  end
end

