require "rtw/rspec"
require 'stringio'

it 'single testcase should pass' do
  result = it { 1 + 1 }
  expect(result.passed?).to eq(true)
end

it 'should fail if throw error' do
  result = it { raise StandardError }
  expect(result.passed?).to eq(false)
  expect(result.error.class).to eq(StandardError)
end

it 'should display testcase description' do
  begin
    $stdout = StringIO.new
    description = 'should pass'
    it description do
    end
    expect($stdout.string).to eq("#{description}\n")
  ensure
    $stdout = STDOUT
  end
end

it 'should tag failed if testcase is failed' do
  begin
    $stdout = StringIO.new
    description = 'should fail'
    it description do
      raise StandardError
    end
    expect($stdout.string).to eq("#{description} - failed\n")
  ensure
    $stdout = STDOUT
  end
end

it 'should pass if assertion is passed' do
  expect(1).to eq(1)
end

it 'should fail if assert failed' do
  result = it { expect(3).to eq(8) }
  expect(result.passed?).to eq(false)
  expect(result.error.class).to eq(StandardError)
  expect(result.error.to_s).to eq("AssertError - expect: 8;actual: 3;")
end