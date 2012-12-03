class List
  attr_accessor :name, :body, :steps

  def initialize(file)
    fname = File.basename(file)
    @name = fname.sub(File.extname(fname), '')
    @body = File.read(file)
    @steps = parse_steps(@body)
  end

  private

  def parse_steps(body)
    steps = []
    current_step = nil
    body.lines.each do |line|
      next if line.strip.empty?
      if line =~ /^-/
        current_name = line.sub(/^-/,'').strip
        current_step = Step.new(current_name)
        steps << current_step
      elsif current_step
        current_step.body << line
      end
    end
    steps
  end

  class Step
    attr_accessor :name, :body

    def initialize(name, body = '')
      @name = name
      @body = body
    end
  end
end
