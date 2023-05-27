require 'date'

class Runner
  def initialize
    @describe_stack = []
    @hooks_before_stack = []
  end

  def run(testcases)
    describe_id = DateTime.now.strftime('%Y%m%d%H%M%S%L') + (Random.rand * 1000).floor.to_s.ljust(4, '0')
    @describe_stack.push(Struct.new(:results, :describe_id) do
      def failed
        results.select(&:failed?)
      end

      def passed
        results.select(&:passed?)
      end
    end.new([], describe_id))
    instance_eval(&testcases)
    @hooks_before_stack.pop if @hooks_before_stack.size > 0 && describe_id == @hooks_before_stack.last[:describe_id]
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
    @hooks_before_stack.push({ describe_id: @describe_stack.last.describe_id, function: Proc.new { block.call } })
  end

  def it(description = nil)
    @hooks_before_stack.each { |hook| hook[:function].call }
    begin
      yield
      result = TestResult.new(description)
    rescue StandardError => e
      result = TestResult.new(description, e)
    end

    result.print
    parent = @describe_stack.pop
    parent.results << result
    @describe_stack.push(parent)
    result
  end
end