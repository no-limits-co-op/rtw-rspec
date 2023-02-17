require_relative '../../lib/rtw/rspec/rspec'
# TODO: run single testcase
  # TODO: run a testcase
  puts Rspec.it { 1+1 } == true
  puts Rspec.it { throw(StandardError.new) } == false
  # TODO: display the testcase running result, passed or (failed | error information)
  #   show description of testcase
  # TODO: assertion
  #   assert value equals true
  #   assert value equals false
  #   testcase is fail if assertion is fail



