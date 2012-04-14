require 'spec_helper'

describe RPub::Commands::Main do
  let(:buffer) { StringIO.new }

  it 'should default to help text' do
    described_class.new([], buffer).invoke
    buffer.string.should =~ /Display command reference/
  end

  it 'should raise error when a subcommand remains' do
    expect {
      described_class.new(['foo'], buffer).invoke
    }.should raise_error(RPub::InvalidSubcommand)
  end

  it 'should print the version number' do
    described_class.new(['-v'], buffer).invoke
    buffer.string.should =~ /rpub \d+\.\d+\.\d+/
  end

  it 'should print help text' do
    described_class.new(['-h'], buffer).invoke
    buffer.string.should =~ /Display command reference/
  end
end
