require_relative 'rspec/runner.rb'
require_relative 'rspec/matcher.rb'
require_relative 'rspec/assertion.rb'
require_relative 'rspec/test_result.rb'

module Rspec
  def it(description = nil, &block)
    results = describe do
      it description do
        block.call
      end
    end.results
    results.first
  end

  def eq(expectation)
    Matcher.new(expectation, Proc.new { |realistic| realistic.eql? expectation })
  end

  def expect(realistic)
    Assertion.new(realistic)
  end

  def describe(description = nil, &block)
    puts description unless description.nil?
    results = Runner.new.run(block)
    puts "\ntotal: #{results.results.size}, failed: #{results.failed.size}, passed: #{results.passed.size}"
    results
  end

  def it_each(description, data_set, &block)
    describe '' do
      data_set.each do |data|
        it description.gsub(/\$(\d+)/) { |placeholder| data[placeholder.slice(1).to_i] } do
          block.call(*data)
        end
      end
    end
  end

  alias_method :context, :describe
end
