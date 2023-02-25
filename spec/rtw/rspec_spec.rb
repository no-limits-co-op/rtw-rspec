require_relative '../../lib/rtw/rspec/rspec'

# TODO: run single testcase
puts Rspec.it { 1 + 1 } == true
puts Rspec.it { raise StandardError.new } == false

# TODO: display the testcase running result, passed or (failed | error information)
#   TODO: show description of testcase

puts Rspec.it { Rspec.expect(1).to Rspec.eq(1) } == true
puts Rspec.it { Rspec.eq(1).call(1) } == true
puts Rspec.it { Rspec.expect(3).to Rspec.eq(8) } == false