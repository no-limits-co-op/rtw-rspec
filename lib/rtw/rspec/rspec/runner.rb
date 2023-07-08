require 'date'
require_relative 'describe'
require_relative 'hook'
require_relative 'hook_stack'
require_relative 'variable.rb'
require_relative 'matcher.rb'
require_relative 'assertion.rb'
require_relative 'test_case.rb'

class Runner
  attr_reader :hooks_before_stack,
              :hooks_after_stack,
              :let_stack,
              :describe_stack

  def initialize
    @describe_stack = []
    @hooks_after_stack = HookStack.new
    @hooks_before_stack = HookStack.new
    @let_stack = []
  end

  def run(test_suite)
    test_suite.run(self)
    store_results(test_suite)
    test_suite
  end

  def describe(description, &block)
    run(Describe.new(description, block))
  end

  def it(description = nil, &block)
    run(TestCase.new(description, block))
  end

  def store_results(testcase)
    return if @describe_stack.empty?
    parent = @describe_stack.pop
    parent.results.concat(testcase.results)
    @describe_stack.push(parent)
  end

  alias context describe

  def let(var_name, &block)
    variable = store_let_stack(var_name, block)
    variable.insert(self)
  end

  def let!(var_name, &block)
    variable = store_let_stack(var_name, block)
    variable.insert!(self)
  end

  def before(&block)
    store_hooks(block, @hooks_before_stack)
  end

  def after(&block)
    store_hooks(block, @hooks_after_stack)
  end

  def eq(expectation)
    Matcher.new(expectation, Proc.new { |realistic| realistic.eql? expectation })
  end

  def expect(realistic)
    Assertion.new(realistic)
  end

  private

  def store_let_stack(var_name, block)
    variable = Variable.new(var_name, block)
    describe_id = @describe_stack.last.describe_id
    if @let_stack.last && @let_stack.last[:describe_id] == describe_id
      @let_stack.last[:variables].push(variable)
    else
      @let_stack.push({ describe_id: describe_id, variables: [variable] })
    end
    variable
  end

  def store_hooks(block, hooks_stack)
    describe_id = @describe_stack.last.describe_id
    function = Proc.new { block.call }
    hooks_stack.store(describe_id, function)
  end
end
