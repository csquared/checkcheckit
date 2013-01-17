require 'ostruct'
require 'uri'

# Uses the "big bowl of pudding' architecture
class CheckCheckIt::Console
  DEFAULT_URL = 'http://checkcheckit.herokuapp.com/'
  attr_accessor :list_dir
  attr_accessor :out_stream, :in_stream, :web_socket

  def initialize(opts = {})
    @out_stream = opts[:out_stream] || $stdout
    @in_stream  = opts[:in_stream]  || $stdin
    @web_socket = opts[:web_socket] || SocketIO
  end

  def dir
    File.expand_path(@list_dir)
  end

  def run!(args = [])
    @options  = Lucy::Goosey.parse_options(args)
    @options['email'] ||= ENV['CHECKCHECKIT_EMAIL']
    @list_dir = File.expand_path(@options.fetch('home', '~/checkcheckit'))

    if args.length == 0
      puts "No command given"
    else
      method = args.shift
      if respond_to? method
        send method, args
      else
        puts "did not understand: #{method}"
      end
    end
  end

  def debug?
    @options['d'] || @options['debug']
  end

  def start(args)
    target = args.first
    unless target
      puts "No list given.\n\n"
      list(args)
      return
    end
    list_name = Dir[dir + '/*/*'].find{ |fname| fname.include? target }
    if list_name
      list = List.new(list_name)
      if (emails = @options['email']) || @options['live']
        @list_id = list_id = notify_server_of_start(emails, list)
        $stderr.puts web_service_url, list_id if debug?
        url = URI.join(web_service_url, list_id)
        puts "Live at URL: #{url}"

        if @options['open'] || @options['O']
          Process.detach fork{ exec("open #{url}") }
        end

        return if @options['no-cli'] || @options['web-only']

        begin
          @client = web_socket.connect(web_service_url, sync: true) do
            after_start { emit('register', {list_id: list_id}) }
          end
        rescue Errno::ECONNREFUSED, WebSocket::Error, RuntimeError => e
          $stderr.puts "Websocket refused connection - using POST"
          @use_post = true
        end
      end

      step_through_list(list)
    else
      puts "Could not find checklist via: #{target}"
    end
  end

  def list(args)
    puts "# Checklists\n"
    Dir[dir + '/*'].each do |dir|
      top_level_dir = File.basename dir
      puts top_level_dir
      Dir[dir + '/*'].each do |file|
        puts "  " + List.new(file).name
      end
    end
  end

  private
  def step_through_list(list)
    results = Array.new(list.steps.length, false)

    list.steps.each_with_index do |step, i|
      puts "#{fmt_results(results)} Step #{i+1}: #{step.name}"
      puts step.body unless step.body.empty?

      check, notes = nil
      begin
        print "Check: "
        case input = in_stream.gets
        when /^[y|+]$/ || ''
          check = true
        when /^[n|-]$/
          check = false
        else
          check = true
        end

        if @options['notes'] || @options['n']
          print "Notes: "
          notes = in_stream.gets
        end
      rescue Interrupt => e
        puts "\nGoodbye!"
        return
      end

      if check
        update_server_with_step(i)
      end

      results[i] = {
        step: i + 1,
        name: step.name,
        body: step.body,
        check: check,
        result: check ? 'CHECK' : 'FAIL',
        status: check ? 1 : 0,
        notes: notes
      }

      puts
    end

    puts "#{fmt_results(results)} Done"
    save_results(list, results)
  end

  def save_results(list,results)
    report = {
      'list-name' => list.name,
      'results' => results
    }
  end

  def fmt_results(results)
    keys = results.map do |result|
      if result
        result[:check] ? '+' : '-'
      else
        '.'
      end
    end
    "|#{keys.join}|"
  end

  def puts(text = '')
    @out_stream.puts text
  end

  def print(text = '')
    @out_stream.print text
  end

  def web_service_url
    ENV['CHECKCHECKIT_URL'] || DEFAULT_URL
  end

  def post_check(list_id, step_id)
    begin
      url = URI.join(web_service_url, "/#{list_id}/check/#{step_id}").to_s
      Excon.post(url)
    rescue Excon::Errors::SocketError, ArgumentError => e
      puts "Error POSTing to #{url}"
    end
  end

  # Returns id
  def notify_server_of_start(emails, list)
    begin
      response = Excon.post(web_service_url, :body => {
        emails: emails,
        list: list.to_h
      }.to_json,
      :headers => {
        'Content-Type' => 'application/json'
      })
      $stderr.puts response if debug?
      return response.body.gsub('"','')
    rescue Excon::Errors::SocketError => e
      puts "Error connecting to #{web_service_url}"
    end
  end

  def update_server_with_step(i)
    if @client
      @client.emit 'check', {list_id: @list_id, step_id: i}
    elsif @use_post
      post_check(@list_id, i)
    end
  end
end
