$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))
ENV['RACK_ENV'] = 'test'
ENV['CHECKCHECKIT_URL'] = 'http://example.com'

require 'vault-test-tools'
require 'minitest/mock'
require 'fakefs'
require 'checkcheckit'
require 'rr'

module Examples
  def self.create_grocery_list(home)
    dir = File.join(home, 'personal')
    FileUtils.mkdir_p(dir)
    File.open(File.join(dir, 'groceries'), 'w') do |file|
      file << "# These be the groceries\n"
      file << "- pineapple \n"
      file << "- mangoes \n enhance the flavor with \n spice\n"
      file << "- fudge \n best from a place in sutter creek"
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
    console.run! cmd_string.split(' ')
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

  def setup
    super
    reset_console
    FakeFS.activate!
    Excon.defaults[:mock] = true
  end

  def teardown
    super
    FakeFS.deactivate!
    Excon.stubs.clear
  end
end

CheckCheckIt::TestCase = Class.new(Vault::TestCase)
CheckCheckIt::Spec     = Class.new(Vault::Spec)
MiniTest::Spec.register_spec_type //, CheckCheckIt::Spec
Vault::Test.include_in_all Vault::Test::EnvironmentHelpers, ConsoleTestHelpers, RR::Adapters::TestUnit

