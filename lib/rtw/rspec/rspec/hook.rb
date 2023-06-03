class Hook
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