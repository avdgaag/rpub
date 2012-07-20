require 'spec_helper'

describe Rpub::Epub::Toc do
  let(:chapters) { [] }
  let(:config)   { { 'title' => 'title' } }
  let(:book)     { double('book', :uid => 'foo', :chapters => chapters, :config => config) }
  let(:subject)  { described_class.new(book).render }

  it { should have_xpath('/xmlns:ncx') }
  it { should have_xpath('/xmlns:ncx/xmlns:head/xmlns:meta[@name="dtb:uid"][@content="foo"]') }
  it { should have_xpath('/xmlns:ncx/xmlns:head/xmlns:meta[@name="dtb:depth"][@content="2"]') }
  it { should have_xpath('/xmlns:ncx/xmlns:head/xmlns:meta[@name="dtb:totalPageCount"][@content="0"]') }
  it { should have_xpath('/xmlns:ncx/xmlns:head/xmlns:meta[@name="dtb:maxPageNumber"][@content="0"]') }
  it { should have_xpath('/xmlns:ncx/xmlns:docTitle/xmlns:text[text()="title"]') }

  context 'without chapters' do
    it { should_not have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint') }
  end

  context 'with chapters' do
    let(:heading1) { double('heading', :children => [heading2], :value => double('value', :options => { :level => 1, :raw_text => 'chapter title'  }), :attr => { :id => 'foo' }) }
    let(:heading2) { double('heading', :children => [], :value => double('value', :options => { :level => 2, :raw_text => 'chapter title 2' }), :attr => { :id => 'bar' }) }
    let(:toc)      { double('toc', :children => [heading1])}
    let(:chapters) { [double('chapter', :title => 'chapter title', :filename => 'filename', :xml_id => 'id', :toc => toc)] }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint[@id="foo"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:navLabel/xmlns:text[text()="chapter title"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:content[@src="filename#foo"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:navPoint[@id="bar"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:navPoint/xmlns:navLabel/xmlns:text[text()="chapter title 2"]') }
    it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:navPoint/xmlns:content[@src="filename#bar"]') }

    context 'with low max_level' do
      let(:config) { { 'title' => 'title', 'max_level' => 1 } }
      it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint[@id="foo"]') }
      it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:navLabel/xmlns:text[text()="chapter title"]') }
      it { should have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:content[@src="filename#foo"]') }
      it { should_not have_xpath('/xmlns:ncx/xmlns:navMap/xmlns:navPoint/xmlns:navPoint') }
    end
  end
end
