$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))
ENV['RACK_ENV'] = 'test'

require 'minitest/unit'
require 'minitest/spec'
require 'minitest/mock'
require 'fakefs'
require 'checkcheckit'

module Examples
  def self.create_grocery_list(home)
    dir = File.join(home, 'personal')
    FileUtils.mkdir_p(dir)
    File.open(File.join(dir, 'groceries'), 'w') do |file|
      file << "- pineapple "
      file << "\n- mangoes \n enhance the flavor with \n spice "
      file << "\n- fudge \n best from a place in sutter creek"
    end
  end
end

module ConsoleTestHelpers
  # Internal: Runs command lines in tests like their command line invocation.
  #
  # Examples:
  #
  #   # check 'list'
  #
  #   # check 'list deploy'
  #
  #   # check 'start deploy'
  def check(cmd_string)
    console.run! cmd_string.split
  end

  def reset_console
    ## Clear out the output
    @console = nil
  end

  def console
    @console ||= CheckCheckIt::Console.new(out_stream: StringIO.new)
  end

  def output
    console.out_stream.string
  end

  def home
    console.list_dir || '~/checkcheckit'
  end

end

class CheckCheckIt::TestCase < MiniTest::Unit::TestCase
  include ConsoleTestHelpers

  def setup
    super
    reset_console
  end
end

class CheckCheckIt::Spec < MiniTest::Spec
  include ConsoleTestHelpers

  before do
    reset_console
  end
end

MiniTest::Spec.register_spec_type //, CheckCheckIt::Spec
