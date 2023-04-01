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

it 'describe should run a group of testcases' do
  results = describe 'first group' do
    it { expect(3).to eq(3) }
    it { expect(3).to eq(3) }
  end.results

  results.each do |result|
    expect(result.passed?).to eq(true)
  end
end

it 'should count testcases number' do
  results = describe 'testcases with passed and failed' do
    it { expect(1).to eq(2) }
    it { expect(1).to eq(3) }
    it { expect(3).to eq(3) }
    it { expect(3).to eq(3) }
  end

  expect(results.failed.size).to eq(2)
  expect(results.passed.size).to eq(2)
end

# TODO: nested group by using describe & context keyword
#    example:
#       ```
#         describe 'xxx' do
#           context 'yyy' do
#              it 'zzz1' do; end
#              it 'zzz2' do; end
#           end
#         end
#       ```
it 'should run nested testcase' do
  results = describe 'nested testcase level 1' do
    context 'nested testcase level 2' do
      it { expect(81192).to eq(81192) }
      it { expect(3).to eq(3) }
    end
  end

  expect(results.results.size).to eq(2)
end
# TODO: print description of describe & context
#   TODO: print description of describe or context
#   TODO: print format - testcase and testcase group
# TODO: print testcase count
