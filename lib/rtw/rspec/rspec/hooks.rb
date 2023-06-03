class Hooks
  def initialize
    @hooks = []
  end

  def store_hooks(describe_id, function)
    if describe_exist_hooks?(describe_id)
      @hooks.last.add_function(function)
    else
      @hooks.push(Hook.new(describe_id, [function]))
    end
  end

  def release(describe_id)
    @hooks.pop if describe_exist_hooks?(describe_id)
  end

  def execute(reversed = false)
    if reversed
      @hooks.reverse.each(&:invoke_after_hook)
    else
      @hooks.each(&:invoke_before_hook)
    end
  end

  def describe_exist_hooks?(describe_id)
    @hooks.size > 0 && @hooks.last.belong_to?(describe_id)
  end
end