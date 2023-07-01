require "rtw/rspec"

describe 'let' do
  let(:x) { 3 }

  describe 'inner test suite with let definition' do
    let(:y) { 4 }
    it 'can use x let' do
      expect(x).to eq(3)
      expect(y).to eq(4)
    end
  end

  it 'should get variable defined by let and without inner let' do
    expect(x).to eq(3)
    begin
      y
    rescue Exception => e
      expect(e.class).to eq(NameError)
    end
  end

  describe 'let calculate time' do
    flag = false

    let(:calculate) { flag = true }

    it 'should calculate when let variable is invoked' do
      expect(flag).to eq(false)
      calculate
      expect(flag).to eq(true)
    end
  end

  describe 'recalculate' do
    let(:y) { 3 }

    it 'should recalculate variable when running every testcase' do
      expect(y).to eq(3)
      y = 4
    end

    it 'should be same result if invoked multiply' do
      expect(y).to eq(3)
      expect(y).to eq(3)
    end

    counter = 0

    let(:calculate1) do
      counter += 1
      counter
    end

    let(:calculate2) do
      counter += 1
      counter
    end

    it 'should rollback global variable' do
      expect(calculate1).to eq(1)
      expect(calculate2).to eq(2)
      expect(calculate1).to eq(1)
    end
  end


  describe 'let! should calculate before testcase invoked' do
    counter = 0

    let!(:before_calculate) do
      counter += 1
      counter
    end

    let(:calculate) do
      counter += 1
      counter
    end

    it 'should calculate before testcase running' do
      expect(calculate).to eq(2)
    end
  end
end
