require 'date'
require_relative 'describe_instance.rb'

class Runner
  def initialize
    @describe_stack = []
    @hooks_before_stack = []
    @hooks_after_stack = []
  end

  def run(test_suite)
    describe_instance = DescribeInstance.new([])
    @describe_stack.push(describe_instance)
    instance_eval(&test_suite)
    @hooks_before_stack.pop if @hooks_before_stack.size > 0 && describe_instance.describe_id == @hooks_before_stack.last[:describe_id]
    @hooks_after_stack.pop if @hooks_after_stack.size > 0 && describe_instance.describe_id == @hooks_after_stack.last[:describe_id]
    @describe_stack.pop
  end

  def describe(description, &block)
    puts "#{'  ' * @describe_stack.size}#{description}" unless description.nil?
    results = run(block)
    parent = @describe_stack.pop
    parent.results.concat(results.results)
    @describe_stack.push(parent)
  end

  alias context describe

  def before(&block)
    if @hooks_before_stack.size > 0 && @hooks_before_stack.last[:describe_id] == @describe_stack.last.describe_id
      @hooks_before_stack.last[:functions].push(Proc.new { block.call })
    else
      @hooks_before_stack.push({ describe_id: @describe_stack.last.describe_id, functions: [Proc.new { block.call }] })
    end
  end

  def after(&block)
    if @hooks_after_stack.size > 0 && @hooks_after_stack.last[:describe_id] == @describe_stack.last.describe_id
      @hooks_after_stack.last[:functions].push(Proc.new { block.call })
    else
      @hooks_after_stack.push({ describe_id: @describe_stack.last.describe_id, functions: [Proc.new { block.call }] })
    end
  end

  def it(description = nil)
    @hooks_before_stack.each { |hook| hook[:functions].each(&:call) }
    begin
      yield
      result = TestResult.new(description)
    rescue StandardError => e
      result = TestResult.new(description, e)
    end

    @hooks_after_stack.each { |hook| hook[:functions].each(&:call) }

    result.print
    parent = @describe_stack.pop
    parent.results << result
    @describe_stack.push(parent)
    result
  end
end


