module Rspec
  def self.it(description = nil)
    begin
      yield
    rescue StandardError => e
      puts "#{description} - failed" unless description.nil?
      return Struct.new(:error) do
        def passed?
          false
        end
      end.new(e)
    end
    puts description unless description.nil?

    Struct.new(:x) do
      def passed?
        true
      end
    end.new('1')
  end

  def self.eq(expectation)
    Struct.new(:expect) do
      def match(realistic)
        realistic.eql? expect
      end
    end.new(expectation)
  end

  def self.expect(realistic)
    Struct.new(:actual) do
      def to(matcher)
        raise StandardError.new("AssertError - expect: #{matcher.expect};actual: #{actual};") unless matcher.match(actual)
      end
    end
    .new(realistic)
  end
end
