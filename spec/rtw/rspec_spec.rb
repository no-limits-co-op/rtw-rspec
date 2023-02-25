require_relative '../../lib/rtw/rspec/rspec'
require 'stringio'

Rspec.it 'single testcase should pass' do
  result = Rspec.it { 1 + 1 }
  Rspec.expect(result.passed?).to Rspec.eq(true)
end

Rspec.it 'should fail if throw error' do
  result = Rspec.it { raise StandardError }
  Rspec.expect(result.passed?).to Rspec.eq(false)
  Rspec.expect(result.error.class).to Rspec.eq(StandardError)
end

Rspec.it 'should display testcase description' do
  begin
    $stdout = StringIO.new
    description = 'should pass'
    Rspec.it description do
    end
    Rspec.expect($stdout.string).to Rspec.eq("#{description}\n")
  ensure
    $stdout = STDOUT
  end
end

Rspec.it 'should tag failed if testcase is failed' do
  begin
    $stdout = StringIO.new
    description = 'should fail'
    Rspec.it description do
      raise StandardError
    end
    Rspec.expect($stdout.string).to Rspec.eq("#{description} - failed\n")
  ensure
    $stdout = STDOUT
  end
end

Rspec.it 'should pass if assertion is passed' do
  Rspec.expect(1).to Rspec.eq(1)
end

Rspec.it 'should fail if assert failed' do
  result = Rspec.it { Rspec.expect(3).to Rspec.eq(8) }
  Rspec.expect(result.passed?).to Rspec.eq(false)
  Rspec.expect(result.error.class).to Rspec.eq(StandardError)
  Rspec.expect(result.error.to_s).to Rspec.eq("AssertError - expect: 8;actual: 3;")
end