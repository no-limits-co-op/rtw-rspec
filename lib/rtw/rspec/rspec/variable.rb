  class Variable
    def initialize(var_name, block)
      @var_name = var_name
      @block = block
      @result = nil
      @calculated = false
    end

    def insert!(test_suite)
      result = calculate
      test_suite.singleton_class.define_method(@var_name, Proc.new { result })
    end

    def insert(test_suite)
      variable = self
      test_suite.singleton_class.define_method(@var_name, Proc.new { variable.calculate })
    end

    def calculate
      return @result if @calculated

      @calculated = true
      @result = @block.call
    end

    def remove!(test_suite)
      test_suite.singleton_class.undef_method @var_name
    end
  end