require 'ostruct'

class CheckCheckIt::Console
  attr_accessor :list_dir
  attr_accessor :stream

  def initialize(out_stream = nil)
    ARGV.clear
    @list_dir = File.expand_path('~/checkcheckit')
    @stream = out_stream || STDOUT
  end

  def puts(text)
    @stream.puts text
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

  def start(args)
    target = args.join(' ')
    hit = Dir[dir + '/*/*'].find{ |fname| fname.include? target }
    if hit
      List.new(hit).run
    else
      puts "Could not find checklist via: #{target}"
    end
  end

  def list(args)
    puts "# Checklists \n"
    Dir[dir + '/*'].each do |dir|
      team = File.basename dir
      puts team
      Dir[dir + '/*'].each do |file|
        puts "  " + List.new(file).name
      end
    end
  end
end
