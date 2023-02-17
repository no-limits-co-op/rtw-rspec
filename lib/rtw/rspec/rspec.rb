module Rspec
  def self.it
    begin
      yield
    rescue
      return false
    end
    true
  end
end
