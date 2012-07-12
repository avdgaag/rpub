require 'spec_helper'

describe Rpub::Commands::Generate do
  let(:buffer) { StringIO.new }
  before do
    Dir.chdir File.join(FIXTURES_DIRECTORY, 'generate')
  end

  after do
    File.unlink 'styles.css' if File.exist?('styles.css')
    File.unlink 'layout.html' if File.exist?('layout.html')
    File.unlink 'config.yml' if File.exist?('config.yml')
  end

  context 'given a specific option' do
    let(:subject) { described_class.new(['--config'], buffer) }

    it 'should generate one file' do
      expect(&subject.method(:invoke)).to create_file('config.yml')
    end

    it 'should not generate stylesheet' do
      expect(&subject.method(:invoke)).to_not create_file('layout.html', 'styles.css')
    end
  end

  context 'given a no option' do
    let(:subject) { described_class.new(['--no-styles'], buffer) }

    it 'should generate two files' do
      expect(&subject.method(:invoke)).to create_file('layout.html', 'config.yml')
    end

    it 'should not generate stylesheet' do
      expect(&subject.method(:invoke)).to_not create_file('styles.css')
    end
  end

  context 'given no options' do
    let(:subject) { described_class.new([], buffer) }

    it 'should generate three files' do
      expect(&subject.method(:invoke)).to create_file('styles.css', 'layout.html', 'config.yml')
    end

    it 'should not generate existing files' do
      File.open('styles.css', 'w') { |f| f.write 'foo' }
      subject.should_receive(:warn).with('Not overriding styles.css')
      expect(&subject.method(:invoke)).to_not change { File.read('styles.css') }
    end
  end
end
