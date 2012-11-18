require 'helper'

class ListTest < TestCase
  def home
    console.list_dir
  end

  def setup
    super
    FileUtils.mkdir_p(home)
    File.open(File.join(home, 'groceries'), 'w') do |file|
      file << "- pineapple \n - mangoes \n - fudge"
    end
  end

  def test_configurable_directory
  end

  def test_lists_orgs_and_lists
    check "list"
    assert_includes output, "# Checklists"
    assert_includes output, "groceries"
  end
end
