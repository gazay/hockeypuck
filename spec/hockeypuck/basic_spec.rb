require 'hockeypuck'

describe Hockeypuck do

  it 'works' do
    raise 'nope'
  end

  it 'should download file' do
    Hockeypuck.fetch 'http://f.cl.ly/items/2z3B0Q3a212W1J1S182p/hockeypuck.jpg', to: '../tmp'
    File.exists?('../tmp/hockeypuck.jpg').should be_true
  end

end
