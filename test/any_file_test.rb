require 'helper'

class AnyFileTest < CheckCheckIt::TestCase

  def setup
    super
    dir = File.join('/just/another')
    FileUtils.mkdir_p(dir)
    File.open(File.join(dir, 'file'), 'w') do |file|
      file << "- 1\n"
      file << "- 2\n- 3\n"
    end
    console.in_stream  = MiniTest::Mock.new
    console.web_socket = MiniTest::Mock.new
  end

  def test_with_any_file
    3.times { console.in_stream.expect :gets, "y" }
    result = check "start /just/another/file"
    console.in_stream.verify
  end

end
