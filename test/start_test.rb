require 'helper'

class StartTest < CheckCheckIt::TestCase

  def setup
    Examples.create_grocery_list(home)
  end

  def test_list_parses_steps
    console.in_stream = MiniTest::Mock.new
    3.times { console.in_stream.expect :gets, "y" }
    result = check "start groceries"
    console.in_stream.verify
  end

  def test_proper_output_on_no_args
    check "start"
    output.must_include "No list given"
    output.must_include "groceries"
  end

  # When you do
  #
  # check start deploy --email csquared@heroku.com
  #
  # It PUT/POSTS? to the checkcheckit webservice
  #
  # The webservice sends you an email with a link to the list so
  # you can run it on the web.
  def test_email_flag_triggers_live_mode
    check "start --email csquared@heroku.com,thea.lamkin@gmail.com"

  end

  # Same as above but with env set
  def test_reads_email_from_env
    set_env 'CHECKCHECKIT_EMAIL', "csquared@heroku.com,thea.lamkin@gmail.com"

  end

  def test_reads_url_from_env
  end
end

