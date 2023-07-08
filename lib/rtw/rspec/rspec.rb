require_relative 'rspec/runner.rb'
require_relative 'rspec/matcher.rb'
require_relative 'rspec/assertion.rb'
require_relative 'rspec/test_result.rb'

module Rspec
  def it(description = nil, &block)
    describe do
      it description, &block
    end
  end

  def describe(description = nil, &block)
    test_suite = Describe.new(description, block)
    results = Runner.new.run(test_suite)
    puts "\ntotal: #{results.results.size}, failed: #{results.failed.size}, passed: #{results.passed.size}"
    results
  end

  def it_each(description, data_set, &block)
    describe '' do
      data_set.each do |data|
        placeholder_regex = /\$(\d+)/
        to_key = Proc.new { |key| key.to_i }

        if data.is_a?(Hash)
          placeholder_regex = /\$(\w+)/
          to_key = Proc.new { |key| key.to_sym }
        end

        desc = description.gsub(placeholder_regex) { |placeholder| data[to_key.call(placeholder.slice(1..-1))] }
        it desc do
          block.call(data)
        end
      end
    end
  end

  alias_method :context, :describe
end
