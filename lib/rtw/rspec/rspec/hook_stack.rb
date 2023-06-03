class HookStack
  def initialize
    @hooks = []
  end

  def store(describe_id, function)
    @hooks.push(Hook.new(describe_id, function))
  end

  def release!(describe_id)
    @hooks.reject! { |hook| hook.belong_to?(describe_id) }
  end

  def execute
    @hooks.each(&:invoke)
  end

  def execute_reverse
    @hooks.reverse.each(&:invoke)
  end
end
