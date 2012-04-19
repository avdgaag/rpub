require 'spec_helper'

describe Rpub::Commands::Clean do
  before do
    Dir.chdir File.join(FIXTURES_DIRECTORY, 'clean')
  end

  after do
    FileUtils.touch 'preview.html'
    FileUtils.touch 'example.epub'
  end

  it 'should remove example.epub file' do
    expect {
      described_class.new.invoke
    }.to remove_file('example.epub')
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
      FileUtils.rm 'preview.html'
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
