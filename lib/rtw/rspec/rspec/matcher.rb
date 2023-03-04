module Rspec
  class Matcher
    attr_reader :expectation

    def initialize(expect)
      @expectation = expect
    end

    def match(realistic)
      realistic.eql? expectation
    end
  end
end