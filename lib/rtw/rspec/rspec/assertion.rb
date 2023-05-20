module Rspec
  class Assertion
    def initialize(actual)
      @actual = actual
    end

    def to(matcher)
      raise StandardError.new("AssertError - expect: #{matcher.expectation};actual: #{@actual};") unless matcher.match(@actual)
    end

    def not_to(matcher)
      to(matcher.not)
    end

  end
end