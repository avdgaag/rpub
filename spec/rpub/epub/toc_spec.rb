require 'spec_helper'

describe Rpub::Epub::Toc do
  let(:chapters) { [] }
  let(:book)     { double('book', :uid => 'foo', :title => 'title', :chapters => chapters) }
  let(:subject)  { described_class.new(book).render }

  it { should have_xpath('/xmlns:ncx') }
  it { should have_xpath('/xmlns:ncx/xmlns:head/xmlns:meta[@name="dtb:uid"][@content="foo"]') }
  it { should have_xpath('/xmlns:ncx/xmlns:head/xmlns:meta[@name="dtb:depth"][@content="1"]') }
  it { should have_xpath('/xmlns:ncx/xmlns:head/xmlns:meta[@name="dtb:totalPageCount"][@content="0"]') }
  it { should have_xpath('/xmlns:ncx/xmlns:head/xmlns:meta[@name="dtb:maxPageNumber"][@content="0"]') }
  it { should have_xpath('/xmlns:ncx/xmlns:docTitle/xmlns:text[text()="title"]') }

  context 'without chapters' do
    it { should_not have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint') }
  end

  context 'with chapters' do
    let(:chapters) { [double('chapter', :title => 'chapter title', :filename => 'filename', :id => 'id')] }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint[@id="id"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:navLabel/xmlns:text[text()="chapter title"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:content[@src="filename"]') }
  end
end
