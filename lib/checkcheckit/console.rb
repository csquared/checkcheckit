require 'ostruct'

class CheckCheckIt::Console
  attr_accessor :list_dir
  attr_accessor :stream, :in_stream

  def initialize(opts = {})
    ARGV.clear
    default_dir = opts.fetch(:dir, '~/checkcheckit')
    @list_dir = File.expand_path(default_dir)
    @stream    = opts[:out_stream] || STDOUT
    @in_stream = opts[:in_stream] || STDIN
  end

  def puts(text = '')
    @stream.puts text
  end

  def print(text = '')
    @stream.print text
  end

  def run!(args)
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

  def dir
    File.expand_path(@list_dir)
  end

  def step_through_list(list)
    results = Array.new(list.steps.length, false)

    list.steps.each_with_index do |step, i|
      puts "#{fmt_results(results)} Step #{i+1}: #{step.name}"
      puts step.body unless step.body.empty?
      print "Check: "

      case input = in_stream.gets
      when /^[y|+]$/ || ''
        results[i] = true
      when /^[n|-]$/
        results[i] = false
      else
        results[i] = false
      end
      puts
    end

    msg = results.all? { |r| r } ? "Done" : "Issues"
    puts "#{fmt_results(results)} #{msg}"
    save_results(list, results)
  end

  def save_results(list,results)
    report = {
      'list-name' => list.name,
      'results' => []
    }
    list.steps.each_with_index do |step, i|
      report['results'] << {
        index: i,
        name: step.name,
        body: step.body,
        result: results[i] ? 'CHECK' : 'FAIL',
        status: results[i] ? 1 : 0,
      }
    end
    report
  end

  def start(args)
    target = args.join(' ')
    hit = Dir[dir + '/*/*'].find{ |fname| fname.include? target }
    if hit
      step_through_list(List.new(hit))
    else
      puts "Could not find checklist via: #{target}"
    end
  end

  def list(args)
    puts "# Checklists\n"
    Dir[dir + '/*'].each do |dir|
      team = File.basename dir
      puts team
      Dir[dir + '/*'].each do |file|
        puts "  " + List.new(file).name
      end
    end
  end

  private
  def fmt_results(results)
    "|#{results.map { |r| r ? '+' : '-' }.join}|"
  end
end
