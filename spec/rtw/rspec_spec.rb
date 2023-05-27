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
    description = <<~DESC
      should pass

      total: 1, failed: 0, passed: 1
    DESC
    it 'should pass' do
    end
    expect($stdout.string).to eq(description)
  ensure
    $stdout = STDOUT
  end
end

it 'should tag failed if testcase is failed' do
  begin
    $stdout = StringIO.new
    description = <<~DESC
      should fail - failed

      total: 1, failed: 1, passed: 0
    DESC
    it 'should fail' do
      raise StandardError
    end
    expect($stdout.string).to eq(description)
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

it 'should run nested testcase' do
  results = describe 'nested testcase level 1' do
    context 'nested testcase level 2' do
      it { expect(81192).to eq(81192) }
      it { expect(3).to eq(3) }
    end
  end

  expect(results.results.size).to eq(2)
end

it 'should run multiple level nested testcase' do
  results = describe 'nested testcase level 1' do
    context 'nested testcase level 2' do
      describe 'nested testcase level 3' do
        it { expect(81192).to eq(81192) }
        it { expect(3).to eq(3) }
      end
    end
  end

  expect(results.results.size).to eq(2)
end

it 'should print description and run statistic of describe and context' do
  begin
    $stdout = StringIO.new
    describe 'nested testcase level 1' do
      context 'nested testcase level 2' do
        describe 'nested testcase level 3' do
          it { expect(81192).to eq(81192) }
          it { expect(3).to eq(2) }
        end
      end
    end

    description = <<~DESC
      nested testcase level 1
        nested testcase level 2
          nested testcase level 3
    
      total: 2, failed: 1, passed: 1
    DESC

    expect($stdout.string).to eq(description)
  ensure
    $stdout = STDOUT
  end
end

it 'should assert not_to' do
  expect(2).not_to eq(3)
end

it 'should generate dynamic description with Array' do
  begin
    $stdout = StringIO.new
    it_each 'should be $2 if add $0 and $1', [[1, 1, 2], [0, -1, -1]] do
    end
    description = <<~DESC

      should be 2 if add 1 and 1
      should be -1 if add 0 and -1
    
      total: 2, failed: 0, passed: 2
    DESC

    expect($stdout.string).to eq(description)
  ensure
    $stdout = STDOUT
  end
end

it 'should generate dynamic testcase block with Array' do
  results = it_each 'should be $2 if add $0 and $1', [[1, 1, 2], [0, -1, -1]] do |a, b, c|
    expect(a + b).to eq(c)
  end

  expect(results.results.size).to eq(2)
  expect(results.passed.size).to eq(2)

  results = it_each 'should be $2 if add $0 and $1', [[2, 1, 2], [1, -1, -1]] do |a, b, c|
    expect(a + b).not_to eq(c)
  end

  expect(results.results.size).to eq(2)
  expect(results.passed.size).to eq(2)
end

it 'should generate dynamic testcase description with Hash' do
  begin
    $stdout = StringIO.new
    it_each 'should be $result if add $a and $b', [{ a: 1, b: 1, result: 2 }, { a: 0, b: -1, result: -1 }] do
    end
    description = <<~DESC

      should be 2 if add 1 and 1
      should be -1 if add 0 and -1

      total: 2, failed: 0, passed: 2
    DESC

    expect($stdout.string).to eq(description)
  ensure
    $stdout = STDOUT
  end
end

it 'should generate dynamic testcase block with Hash' do
  results = it_each 'should be $result if add $a and $b', [{ a: 1, b: 1, result: 2 }, { a: 0, b: -1, result: -1 }] do |result:, a:, b:|
    expect(a + b).to eq(result)
  end

  expect(results.results.size).to eq(2)
  expect(results.passed.size).to eq(2)

  results = it_each 'should be $result if add $a and $b', [{ a: 2, b: 1, result: 2 }, { a: 1, b: -1, result: -1 }] do |b:, a:, result:|
    expect(a + b).to eq(result)
  end

  expect(results.results.size).to eq(2)
  expect(results.failed.size).to eq(2)
end

it 'should run single before hook before run it' do
  describe 'within single level before hook' do
    test_counter = 0
    before do
      test_counter += 1
    end
    it 'should test_counter equals 1' do
      expect(test_counter).to eq(1)
    end
    it 'should test_counter equals 2' do
      expect(test_counter).to eq(2)
    end
  end
end

it 'should run nested levels before hook' do
  results = describe 'outer level before hook' do
    outer_running = false
    inner_running = false
    outer_counter = 0
    inner_counter = 0

    before do
      outer_running = true
      outer_counter += 1
      puts 'outer'
    end

    describe 'nested describe' do
      before do
        inner_running = true
        inner_counter += 1
      end

      it 'should inner var equals 2 and outer var equals 0' do
        expect(inner_running).to eq(true)
        expect(inner_counter).to eq(1)
        expect(outer_counter).to eq(1)
      end
    end

    it 'should outer var equals 0 and inner var can\'t equals 2' do
      expect(outer_running).to eq(true)
      expect(inner_counter).to eq(1)
      expect(outer_counter).to eq(2)
    end
  end
  expect(results.passed.size).to eq(2)
end

it 'should run multiple before hooks before run it' do
  describe 'within single level before hook' do
    test_counter = 0
    before do
      test_counter += 1
    end
    describe 'nested before describe' do
      before do
        test_counter += 1
      end
      before do
        test_counter += 1
      end
      it 'should do nothing' do; end
    end

    it 'should test_counter equals 4' do
      expect(test_counter).to eq(4)
    end
    it 'should test_counter equals 5' do
      expect(test_counter).to eq(5)
    end
  end
end
