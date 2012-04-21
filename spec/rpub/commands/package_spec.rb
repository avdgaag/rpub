require 'spec_helper'

describe Rpub::Commands::Package do
  before do
    Dir.chdir File.join(FIXTURES_DIRECTORY, 'package')
  end

  after do
    File.unlink('package.zip') if File.exist?('package.zip')
  end

  it 'should generate an archive' do
    expect(&subject.method(:invoke)).to create_file('package.zip')
  end

  context 'archive file' do
    before { described_class.new.invoke }

    let(:subject) do
      [].tap do |files|
        Zip::ZipInputStream.open('package.zip') do |io|
          while entry = io.get_next_entry
            files << entry.name
          end
        end
      end
    end

    it { should include('README.md') }
    it { should include('untitled-book-0.0.0.epub') }
  end
end
