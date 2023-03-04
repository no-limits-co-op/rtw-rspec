module Rspec
  class Assertion
    def initialize(actual)
      @actual = actual
    end

    def to(matcher)
      raise StandardError.new("AssertError - expect: #{matcher.expectation};actual: #{@actual};") unless matcher.match(@actual)
    end
  end
end