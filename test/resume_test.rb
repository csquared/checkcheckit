require 'helper'

describe 'Resuming a checklist' do
  def setup
    super
    Examples.create_grocery_list(home)
  end

  #TODO: verify though the console

  it "should record the pass/fail of each step" do
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
    console.in_stream.verify
    console.out_stream.verify
    result["results"][0][:result].must_equal "FAIL"
    result["results"][0][:status].must_equal 0
    result["results"][1][:result].must_equal "CHECK"
    result["results"][1][:status].must_equal 1
    result["results"][2][:result].must_equal "FAIL"
    result["results"][2][:status].must_equal 0
  end

  it "should record the name of each step" do
    console.in_stream = MiniTest::Mock.new
    6.times { console.in_stream.expect :gets, "y" }
    result = check "start groceries"
    console.in_stream.verify
    result["results"][0][:name].must_equal "pineapple"
    result["results"][1][:name].must_equal "mangoes"
    result["results"][2][:name].must_equal "fudge"
  end

  it "should record the body of each step" do
    console.in_stream = MiniTest::Mock.new
    6.times { console.in_stream.expect :gets, "y" }
    result = check "start groceries"
    console.in_stream.verify
=begin
    result["results"][0][:body].must_equal ""
    result["results"][1][:name].must_equal "enhance the flavor with \n spice"
    result["results"][2][:name].must_equal "best from a place in sutter creek"
=end
  end
end


