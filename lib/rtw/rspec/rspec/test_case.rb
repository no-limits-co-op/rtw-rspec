class TestCase
  attr_reader :result

  def initialize(result = nil)
    @result = result
  end

  def results
    [@result]
  end

  def run(description, block, before_hooks, after_hooks, runner)
    before_hooks.execute
    begin
      runner.instance_eval(&block)
      @result = TestResult.new(description)
    rescue StandardError => e
      @result = TestResult.new(description, e)
    end

    after_hooks.execute_reverse
    @result.print
    self
  end
end