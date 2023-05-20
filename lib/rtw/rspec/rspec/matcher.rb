module Rspec
  class Matcher
    attr_reader :expectation

    def initialize(expect, matcher)
      @expectation = expect
      @matcher = matcher
    end

    def match(realistic)
      @matcher.call(realistic, expectation)
    end

    def not
      Matcher.new(@expectation, Proc.new { |realistic, expectation| !@matcher.call(realistic, expectation) })
    end
  end
end