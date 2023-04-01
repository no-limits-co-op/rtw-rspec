require_relative 'rspec/matcher.rb'
require_relative 'rspec/assertion.rb'
require_relative 'rspec/test_result.rb'

module Rspec
  def it(description = nil, &block)
    results = describe do
      it description do
        block.call
      end
    end.results
    results.first
  end

  def eq(expectation)
    Matcher.new(expectation)
  end

  def expect(realistic)
    Assertion.new(realistic)
  end

  def describe(description = nil, &block)
    puts description unless description.nil?
    results = Runner.new.run(block)
    puts "\ntotal: #{results.results.size}, failed: #{results.failed.size}, passed: #{results.passed.size}"
    results
  end

  alias_method :context, :describe
end

class Runner
  def initialize
    @describe_stack = []
  end

  def run(testcases)
    @describe_stack.push(Struct.new(:results) do
      def failed
        results.select(&:failed?)
      end

      def passed
        results.select(&:passed?)
      end
    end.new([]))
    instance_eval(&testcases)
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

  def it(description = nil)
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
