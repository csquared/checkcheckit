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


  def test_default_no_notes
    console.in_stream = MiniTest::Mock.new
    console.out_stream = MiniTest::Mock.new

    9.times do
      console.out_stream.expect :puts, true, [String]
    end
    3.times do
      console.out_stream.expect :print, true, ["Check: "]
    end
    console.in_stream.expect :gets, "n"
    console.in_stream.expect :gets, "y"
    console.in_stream.expect :gets, "n"
    result = check "start groceries"
  end

  def test_includes_notes
    console.in_stream  = MiniTest::Mock.new
    console.out_stream = MiniTest::Mock.new

    9.times do
      console.out_stream.expect :puts, true, [String]
    end
    3.times do
      console.out_stream.expect :print, true, ["Check: "]
      console.out_stream.expect :print, true, ["Notes: "]
    end
    console.in_stream.expect :gets, "n"
    console.in_stream.expect :gets, "Shit's fucked"
    console.in_stream.expect :gets, "y"
    console.in_stream.expect :gets, ""
    console.in_stream.expect :gets, "n"
    console.in_stream.expect :gets, "Really, bad"
    check "start groceries --notes"
    console.in_stream.verify
    console.out_stream.verify
  end
end
