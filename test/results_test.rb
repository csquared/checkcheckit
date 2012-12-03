require 'helper'

describe 'Storing Results after a run' do
  def setup
    super
    dir = File.join(home, 'personal')
    FileUtils.mkdir_p(dir)
    File.open(File.join(dir, 'groceries'), 'w') do |file|
      file << "- pineapple \n- mangoes \n- fudge"
    end
  end

  it "should enumerate the list items" do
    console.in_stream = MiniTest::Mock.new
    console.in_stream.expect :gets, "n"
    console.in_stream.expect :gets, "n"
    console.in_stream.expect :gets, "n"
    result = check "start groceries"
    console.in_stream.verify
    p result
  end
end

