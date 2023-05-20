module Rspec
  class Matcher
    attr_reader :expectation

    def initialize(expect, matcher)
      @expectation = expect
      @matcher = matcher
    end

    def match(realistic)
      @matcher.call(realistic)
    end

    def not
      Matcher.new(@expectation, Proc.new { |realistic| !@matcher.call(realistic) })
    end
  end
end