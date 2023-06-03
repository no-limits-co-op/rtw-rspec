require 'date'
require_relative 'describe.rb'

class Runner
  def initialize
    @describe_stack = []
    @hooks_before_stack = []
    @hooks_after_stack = []
  end

  def run(test_suite)
    describe_instance = Describe.new([])
    @describe_stack.push(describe_instance)
    instance_eval(&test_suite)
    @hooks_before_stack.pop if @hooks_before_stack.size > 0 && @hooks_before_stack.last.belong_to?(describe_instance.describe_id)
    @hooks_after_stack.pop if @hooks_after_stack.size > 0 && @hooks_after_stack.last.belong_to?(describe_instance.describe_id)
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
    stack_hooks(block, @hooks_before_stack)
  end

  def after(&block)
    stack_hooks(block, @hooks_after_stack)
  end

  def it(description = nil)
    @hooks_before_stack.each(&:invoke_before_hook)
    begin
      yield
      result = TestResult.new(description)
    rescue StandardError => e
      result = TestResult.new(description, e)
    end

    @hooks_after_stack.reverse.each(&:invoke_after_hook)

    result.print
    parent = @describe_stack.pop
    parent.results << result
    @describe_stack.push(parent)
    result
  end

  private

  def stack_hooks(block, hook_stack)
    describe_id = @describe_stack.last.describe_id
    function = Proc.new { block.call }
    if hook_stack.size > 0 && hook_stack.last.belong_to?(describe_id)
      hook_stack.last.add_function(function)
    else
      hook = Hook.new(describe_id, [function])
      hook_stack.push(hook)
    end
  end
end

class Hook
  attr_accessor :describe_id, :functions

  def initialize(describe_id, functions)
    @describe_id = describe_id
    @functions = functions
  end

  def invoke_before_hook
    @functions.each(&:call)
  end

  def invoke_after_hook
    @functions.reverse.each(&:call)
  end

  def belong_to?(describe_id)
    @describe_id == describe_id
  end

  def add_function(function)
    @functions.push(function)
  end
end
