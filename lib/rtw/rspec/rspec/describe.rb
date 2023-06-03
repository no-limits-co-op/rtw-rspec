class Describe
  attr_reader :describe_id, :results

  def initialize(results)
    @results = results
    @describe_id = DateTime.now.strftime('%Y%m%d%H%M%S%L') + (Random.rand * 1000).floor.to_s.ljust(4, '0')
  end

  def failed
    results.select(&:failed?)
  end

  def passed
    results.select(&:passed?)
  end
end