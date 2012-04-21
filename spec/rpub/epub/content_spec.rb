require 'spec_helper'

describe Rpub::Epub::Content do
  let(:book) do
    double('book', {
      :creator     => 'anonymous',
      :title       => 'title',
      :language    => 'en',
      :publisher   => 'none',
      :description => 'foo bar',
      :subject     => 'baz qux',
      :rights      => 'copyright',
      :uid         => 'abcd',
      :has_cover?  => false,
      :has_fonts?  => false,
      :has_toc?    => false,
      :images      => [],
      :chapters    => []
    })
  end
  let(:subject) { described_class.new(book).render }

  def self.it_should_have_metadata(name, value, options = {})
    attr = options.inject('') do |str, (k, v)|
      str << "[@#{k}=\"#{v}\"]"
    end
    it { should have_xpath(%Q{/xmlns:package/xmlns:metadata/dc:#{name}[text()="#{value}"]#{attr}}, 'dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns' => 'http://www.idpf.org/2007/opf') }
  end

  context 'with an empty book' do

    it { should have_xpath('/xmlns:package[@unique-identifier="BookId"][@version="2.0"]') }
    it { should have_xpath('/xmlns:package[@unique-identifier="BookId"][@version="2.0"]') }

    it_should_have_metadata 'title', "title"
    it_should_have_metadata 'creator', "anonymous", 'xmlns:role' => 'aut'
    it_should_have_metadata 'publisher', "none"
    it_should_have_metadata 'subject', "baz qux"
    it_should_have_metadata 'identifier', "abcd", :id => 'BookId'
    it_should_have_metadata 'rights', "copyright"
    it_should_have_metadata 'description', "foo bar"
  end

  context 'when the book has a cover' do
    before { book.stub! :has_cover? => true, :cover_image => 'foo.jpg' }
    it { should have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="cover"][@href="cover.html"][@media-type="application/xhtml+xml"]') }
    it { should have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="cover-image"][@href="foo.jpg"][@media-type="image/jpeg"]') }
    it { should have_xpath('/xmlns:package/xmlns:metadata/xmlns:meta[@name="cover"][@content="cover-image"]') }
    it { should have_xpath('/xmlns:package/xmlns:guide/xmlns:reference[@type="cover"][@title="Cover"][@href="cover.html"]') }
    it { should have_xpath('/xmlns:package/xmlns:spine[@toc="ncx"]/xmlns:itemref[@idref="cover"][@linear="no"]') }
  end

  context 'when the book has embedded fonts' do
    before { book.stub! :has_fonts? => true, :fonts => ['font.otf'] }
    it { should have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="font.otf"][@href="font.otf"][@media-type="font/opentype"]') }
  end

  context 'when the book has a ToC' do
    before { book.stub! :has_toc? => true }
    it { should have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="toc"][@href="toc.html"][@media-type="application/xhtml+xml"]') }
  end

  context 'when the book has images' do
    before { book.stub! :images => ['foo.png', 'bar.gif'] }
    it { should have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="foo.png"][@href="foo.png"][@media-type="image/png"]') }
    it { should have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="bar.gif"][@href="bar.gif"][@media-type="image/gif"]') }
  end

  context 'when the book has chapters' do
    let(:chapter) { double('chapter', :filename => 'chapter.html', :xml_id => 'chapter1') }
    before { book.stub! :chapters => [chapter] }
    it { should have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="chapter1"][@href="chapter.html"][@media-type="application/xhtml+xml"]') }
    it { should have_xpath('/xmlns:package/xmlns:spine[@toc="ncx"]/xmlns:itemref[@idref="chapter1"]') }
  end
end
