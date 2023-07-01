require "rtw/rspec"

describe 'let' do
  let(:x) { 3 }


  describe 'y' do
    let(:y) {4}
    it 'can use x let' do
      expect(x).to eq(3)
      expect(y).to eq(4)
    end
  end

  it 'should get variable defined by let' do
    expect(x).to eq(3)
    expect(y).to eq(nil)
  end
  # TODO: should calculate when variable is invoked
  # TODO: should recalculate when running every testcases
  # TODO: should calculate same result if it is invoked multiply in same testcase
  # TODO: should calculate before invoked when variable is defined by let!
end
