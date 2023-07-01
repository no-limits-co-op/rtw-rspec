require 'date'
require_relative 'describe'
require_relative 'hook'
require_relative 'hook_stack'

class Runner
  def initialize
    @describe_stack = []
    @hooks_after_stack = HookStack.new
    @hooks_before_stack = HookStack.new
    @let_stack = []
  end

  def run(test_suite)
    describe_instance = Describe.new([])
    @describe_stack.push(describe_instance)
    instance_eval(&test_suite)
    @hooks_before_stack.release!(describe_instance.describe_id)
    @hooks_after_stack.release!(describe_instance.describe_id)
    lets = @let_stack.pop
    lets[:name].each do |var_name|
      remove_instance_variable("@#{var_name}")
    end
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

  def let(var_name)
    describe_id = @describe_stack.last.describe_id
    instance_variable_name = "@#{var_name}"
    if @let_stack.last && @let_stack.last[:describe_id] == describe_id
      @let_stack.last[:name].push(var_name)
    else
      @let_stack.push({ describe_id: describe_id, name: [var_name] })
    end
    instance_variable_set(instance_variable_name, yield)
    singleton_class.class_eval { attr_reader var_name.to_s }
  end

  def before(&block)
    store_hooks(block, @hooks_before_stack)
  end

  def after(&block)
    store_hooks(block, @hooks_after_stack)
  end

  def it(description = nil)
    @hooks_before_stack.execute
    begin
      yield
      result = TestResult.new(description)
    rescue StandardError => e
      result = TestResult.new(description, e)
    end

    @hooks_after_stack.execute_reverse

    result.print
    parent = @describe_stack.pop
    parent.results << result
    @describe_stack.push(parent)
    result
  end

  private

  def store_hooks(block, hooks_stack)
    describe_id = @describe_stack.last.describe_id
    function = Proc.new { block.call }
    hooks_stack.store(describe_id, function)
  end
end
