class List
  attr_accessor :name, :body, :steps

  def initialize(file)
    fname = File.basename(file)
    @name = fname.sub(File.extname(fname), '')
    @body = File.read(file)
    @steps = parse_steps(@body)
  end

  def run
    results = Array.new(@steps.length, false)

    @steps.each_with_index do |step, i|
      puts "#{fmt_results(results)} Step #{i+1}: #{step.name}"
      puts step.body unless step.body.empty?
      step.commands.each do |cmd|
        system cmd
      end

      print "Check: "

      case input = gets
      when /^[y|+|ch]/ || ''
        results[i] = true
      when /^[n|-]/
        results[i] = false
      else
        results[i] = true
      end
      puts
    end

    msg = results.all? { |r| r } ? "Done" : "Issues"
    puts "#{fmt_results(results)} #{msg}"
  end

  private
  def fmt_results(results)
    "|#{results.map { |r| r ? '+' : '-' }.join}|"
  end

  def parse_steps(body)
    steps = []
    current_step = nil
    body.lines.each do |line|
      next if line.strip.empty?
      if line =~ /^-/
        current_name = line.sub(/^-/,'').strip
        current_step = Step.new(current_name)
        steps << current_step
      else
        current_step.commands << line.gsub('`','') if line =~ /`/
        current_step.body << line
      end
    end
    steps
  end

  class Step
    attr_accessor :name, :body, :commands

    def initialize(name, body = '', commands = [])
      @name = name
      @body = body
      @commands = commands
    end
  end
end
