$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))
ENV['RACK_ENV'] = 'test'

require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'

require 'fakefs'

require 'checkcheckit'

class TestCase < MiniTest::Unit::TestCase
  # Internal: Runs command lines in tests like their command line invocation.
  #
  # Examples:
  #
  #   # check 'list'
  #
  #   # check 'list deploy'
  #
  #   # check 'start deploy'
  def check(*args)
    console.run! args
  end

  def setup
    super
    ## Clear out the output
    console.stream.string.clear
  end

  def output
    console.stream.string
  end


  def console
    @console ||= CheckCheckIt::Console.new(StringIO.new)
  end
end
