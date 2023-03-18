require_relative 'rspec/matcher.rb'
require_relative 'rspec/assertion.rb'
require_relative 'rspec/test_result.rb'

module Rspec
  def it(description = nil, &block)
    results = describe '' do
      it description do
        block.call
      end
    end
    results.first
  end

  def eq(expectation)
    Matcher.new(expectation)
  end

  def expect(realistic)
    Assertion.new(realistic)
  end

  def describe(description = nil, &block)
    Runner.new.run(block)
  end

  class Runner
    def initialize
      @stack = []
    end

    def run(testcases)
      @stack.push(Struct.new(:results).new([]))
      instance_eval(&testcases)
      @stack.pop.results
    end

    def it(description = nil)
      begin
        yield
        result = TestResult.new(description)
      rescue StandardError => e
        result = TestResult.new(description, e)
      end

      result.print
      parent = @stack.pop
      parent.results << result
      @stack.push(parent)
      result
    end
  end
end
