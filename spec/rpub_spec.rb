require 'spec_helper'

describe RPub do
  it 'should define a version number' do
    RPub::VERSION.should =~ /\d+\.\d+\.\d+/
  end
end
