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

# TODO: describe a group of testcase
#   run testcase by group
# TODO: statistic the number of all testcases
#   TODO: failed number
#   TODO: success number
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
# TODO: print description of describe & context
#   TODO: print description of describe or context
#   TODO: print format - testcase and testcase group
# TODO: print testcase count
