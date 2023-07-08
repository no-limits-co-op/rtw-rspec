class TestCase
  attr_reader :result

  def initialize(description, block)
    @description = description
    @block = block
    @result = nil
  end

  def results
    [@result]
  end

  def run(runner)
    runner.hooks_before_stack.execute
    begin
      runner.instance_eval(&@block)
      @result = TestResult.new(@description)
    rescue StandardError => e
      @result = TestResult.new(@description, e)
    end

    runner.hooks_after_stack.execute_reverse
    @result.print
    self
  end
end