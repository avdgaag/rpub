require 'spec_helper'

describe RPub::Commands::Clean do
  before do
    Dir.chdir File.join(FIXTURES_DIRECTORY, 'clean')
  end

  after do
    FileUtils.touch 'preview.html'
  end

  it 'should remove preview.html file' do
    expect {
      described_class.new.invoke
    }.to remove_file('preview.html')
  end

  context 'when in dry run mode' do
    let(:buffer) { StringIO.new }
    let(:subject) { described_class.new(['-d'], buffer) }

    it 'should print preview.html' do
      subject.invoke
      buffer.string.should include('preview.html')
    end

    it 'should not print non-existant files' do
      File.should_receive(:exist?).with('preview.html').and_return(false)
      subject.invoke
      buffer.string.should_not include('preview.html')
    end

    it 'should not remove existing files' do
      expect {
        subject.invoke
      }.to_not remove_file('preview.html')
    end
  end
end
