require_relative 'rspec/matcher.rb'
require_relative 'rspec/assertion.rb'
require_relative 'rspec/test_result.rb'

module Rspec
  def self.it(description = nil)
    begin
      yield
      result = TestResult.new(description)
    rescue StandardError => e
      result = TestResult.new(description, e)
    end

    result.print
    return result
  end

  def self.eq(expectation)
    Matcher.new(expectation)
  end

  def self.expect(realistic)
    Assertion.new(realistic)
  end
end
