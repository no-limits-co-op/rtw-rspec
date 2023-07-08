class Describe
  attr_reader :describe_id, :results

  def initialize(results)
    @results = results
    @describe_id = DateTime.now.strftime('%Y%m%d%H%M%S%L') + (Random.rand * 1000).floor.to_s.ljust(4, '0')
  end

  def failed
    results.select(&:failed?)
  end

  def passed
    results.select(&:passed?)
  end

  def run(description, block, runner)
    puts "#{'  ' * runner.describe_stack.size}#{description}" unless description.nil?
    describe_instance = Describe.new([])
    runner.describe_stack.push(describe_instance)
    runner.instance_eval(&block)
    runner.hooks_before_stack.release!(describe_instance.describe_id)
    runner.hooks_after_stack.release!(describe_instance.describe_id)
    lets = runner.let_stack.pop
    lets[:variables].each do |variable|
      variable.remove!(runner)
    end if lets
    runner.describe_stack.pop
  end
end