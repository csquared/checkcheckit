require 'helper'

class StartTest < CheckCheckIt::TestCase

  def setup
    super
    Examples.create_grocery_list(home)
    console.in_stream  = MiniTest::Mock.new
    console.web_socket = MiniTest::Mock.new
  end

  def mock_web_socket
    client = MiniTest::Mock.new
    console.web_socket.expect :connect, client, [String, {sync: true}]
    client
  end

  def test_list_parses_steps
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
  # check start deploy --live
  #
  # we setup the POST with the list data
  def test_live_flag_triggers_live_mode
    client = mock_web_socket
    3.times { client.expect :emit, true, ['check', Hash] }
    Excon.stub({:method => :post, :body => {
      emails: nil,
      list:   List.new(home + '/personal/groceries').to_h
    }.to_json}, {:status => 200})
    3.times { console.in_stream.expect :gets, "y" }
    check "start groceries --live"
  end

  # When you do
  #
  # check start deploy --email csquared@heroku.com
  #
  # The webservice sends you an email with a link to the list so
  # you can run it on the web.
  def test_email_flag_triggers_live_mode
    client = mock_web_socket
    3.times { client.expect :emit, true, ['check', Hash] }
    Excon.stub({:method => :post, :body => {
      emails: "csquared@heroku.com,thea.lamkin@gmail.com",
      list:   List.new(home + '/personal/groceries').to_h
    }.to_json}, {:status => 200})
    3.times { console.in_stream.expect :gets, "y" }
    check "start groceries --email csquared@heroku.com,thea.lamkin@gmail.com"
  end

  # Same as above but with env set
  def test_reads_email_from_env
    set_env 'CHECKCHECKIT_EMAIL', "csquared@heroku.com,thea.lamkin@gmail.com"
    client = mock_web_socket
    3.times { client.expect :emit, true, ['check', Hash] }
    Excon.stub({:method => :post, :body => {
      emails: "csquared@heroku.com,thea.lamkin@gmail.com",
      list:   List.new(home + '/personal/groceries').to_h
    }.to_json}, {:status => 200})
    3.times { console.in_stream.expect :gets, "y" }
    check "start groceries"
  end

  def test_live_only_sends_on_success
    client = mock_web_socket
    1.times { client.expect :emit, true, ['check', Hash] }
    Excon.stub({:method => :post}, {:status => 200})
    2.times { console.in_stream.expect :gets, "n" }
    1.times { console.in_stream.expect :gets, "y" }
    check "start groceries --live"
  end

  def test_live_falls_back_to_post
    # stub it the old way
    ws = console.web_socket
    def ws.connect(*args); raise WebSocket::Error; end
    4.times { Excon.stub({:method => :post}, {:status => 200}) }
    3.times { console.in_stream.expect :gets, "y" }
    assert_output(//,/POST/) do
      check "start groceries --live"
    end
  end

  def test_reads_url_from_env
    #skip "too lazy to implement"
  end
end

