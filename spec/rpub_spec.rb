require 'spec_helper'

describe Rpub do
  it 'should define a version number' do
    Rpub::VERSION.should =~ /\d+\.\d+\.\d+/
  end
end
