require 'spec_helper'

describe Rpub::Epub::Toc do
  let(:chapters) { [] }
  let(:book)     { double('book', :uid => 'foo', :title => 'title', :chapters => chapters, :config => {}) }
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
    let(:heading1) { double('heading', :level => 1, :text => 'chapter title', :html_id => 'foo') }
    let(:heading2) { double('heading', :level => 2, :text => 'chapter title 2', :html_id => 'bar') }
    let(:chapters) { [double('chapter', :title => 'chapter title', :filename => 'filename', :xml_id => 'id', :outline => [heading1, heading2])] }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint[@id="id-foo"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:navLabel/xmlns:text[text()="chapter title"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:content[@src="filename#foo"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:navPoint[@id="id-bar"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:navPoint/xmlns:navLabel/xmlns:text[text()="chapter title 2"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:navPoint/xmlns:content[@src="filename#bar"]') }
  end
end
