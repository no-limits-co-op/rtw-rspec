module Rspec
  class TestResult
    attr_reader :error

    def initialize(description, error = nil)
      @description = description
      @error = error
    end

    def passed?
      error.nil?
    end

    def print
      puts "#{@description}#{passed? ? '' : ' - failed'}" unless @description.nil?
    end
  end
end