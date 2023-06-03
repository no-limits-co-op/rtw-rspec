class Hook
  def initialize(describe_id, function)
    @describe_id = describe_id
    @function = function
  end

  def invoke
    @function.call
  end

  def belong_to?(describe_id)
    @describe_id == describe_id
  end
end
