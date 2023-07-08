class Describe
  attr_reader :describe_id, :results

  def initialize(description, block)
    @description = description
    @block = block
    @results = []
    @describe_id = DateTime.now.strftime('%Y%m%d%H%M%S%L') + (Random.rand * 1000).floor.to_s.ljust(4, '0')
  end

  def failed
    results.select(&:failed?)
  end

  def passed
    results.select(&:passed?)
  end

  def run(runner)
    puts "#{'  ' * runner.describe_stack.size}#{@description}" unless @description.nil?
    runner.describe_stack.push(self)
    runner.instance_eval(&@block)
    runner.hooks_before_stack.release!(@describe_id)
    runner.hooks_after_stack.release!(@describe_id)
    lets = runner.let_stack.pop
    lets[:variables].each do |variable|
      variable.remove!(runner)
    end if lets
    runner.describe_stack.pop
  end
end