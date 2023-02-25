module Rspec
  def self.it
    begin
      yield
    rescue
      return false
    end
    true
  end

  def self.eq(expectation)
    -> (realistic) { realistic.eql? expectation }
  end

  def self.expect(realistic)
    Struct.new(:actual) do
      def to(matcher)
        raise 'Not match' unless matcher.call(actual)
      end
    end
    .new(realistic)
  end
end
