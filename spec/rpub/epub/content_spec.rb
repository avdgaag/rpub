describe Rpub::Epub::Content do
  let(:config) do
    OpenStruct.new({
      'creator'     => 'anonymous',
      'title'       => 'title',
      'language'    => 'en',
      'publisher'   => 'none',
      'description' => 'foo bar',
      'subject'     => 'baz qux',
      'rights'      => 'copyright',
      'cover_image' => 'image.jpg'
    })
  end
  let(:book) do
    double('book', {
      :config      =>  config,
      :uid         =>  'abcd',
      :has_cover?  =>  false,
      :has_fonts?  =>  false,
      :has_toc?    =>  false,
      :images      =>  [],
      :chapters    =>  []
    })
  end
  let(:subject) { described_class.new(book).render }

  def self.it_should_have_metadata(name, value, options = {})
    attr = options.inject('') do |str, (k, v)|
      str << "[@#{k}=\"#{v}\"]"
    end
    it { is_expected.to have_xpath(%Q{/xmlns:package/xmlns:metadata/dc:#{name}[text()="#{value}"]#{attr}}, 'dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns' => 'http://www.idpf.org/2007/opf') }
  end

  context 'with an empty book' do

    it { is_expected.to have_xpath('/xmlns:package[@unique-identifier="BookId"][@version="2.0"]') }
    it { is_expected.to have_xpath('/xmlns:package[@unique-identifier="BookId"][@version="2.0"]') }

    it_should_have_metadata 'title',       "title"
    it_should_have_metadata 'creator',     "anonymous", 'xmlns:role' => 'aut'
    it_should_have_metadata 'publisher',   "none"
    it_should_have_metadata 'subject',     "baz qux"
    it_should_have_metadata 'identifier',  "abcd",      :id => 'BookId'
    it_should_have_metadata 'rights',      "copyright"
    it_should_have_metadata 'description', "foo bar"
  end

  context 'when the book has a cover' do
    before do
      allow(book).to receive(:has_cover?).and_return(true)
      allow(config).to receive(:cover_image).and_return('foo.jpg')
    end

    it { is_expected.to have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="cover"][@href="cover.html"][@media-type="application/xhtml+xml"]') }
    it { is_expected.to have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="cover-image"][@href="foo.jpg"][@media-type="image/jpeg"]') }
    it { is_expected.to have_xpath('/xmlns:package/xmlns:metadata/xmlns:meta[@name="cover"][@content="cover-image"]') }
    it { is_expected.to have_xpath('/xmlns:package/xmlns:guide/xmlns:reference[@type="cover"][@title="Cover"][@href="cover.html"]') }
    it { is_expected.to have_xpath('/xmlns:package/xmlns:spine[@toc="ncx"]/xmlns:itemref[@idref="cover"][@linear="no"]') }
  end

  context 'when the book has embedded fonts' do
    before do
      allow(book).to receive(:has_fonts?).and_return(true)
      allow(book).to receive(:fonts).and_return(['font.otf'])
    end

    it { is_expected.to have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="font.otf"][@href="font.otf"][@media-type="font/opentype"]') }
  end

  context 'when the book has a ToC' do
    before do
      allow(book).to receive(:has_toc?).and_return(true)
    end

    it { is_expected.to have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="toc"][@href="toc.html"][@media-type="application/xhtml+xml"]') }
    it { is_expected.to have_xpath('/xmlns:package/xmlns:guide/xmlns:reference[@type="toc"][@title="Table of Contents"][@href="toc.html"]') }
  end

  context 'when the book has images' do
    before do
      allow(book).to receive(:images).and_return(['foo.png', 'bar.gif'])
    end

    it { is_expected.to have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="foo.png"][@href="foo.png"][@media-type="image/png"]') }
    it { is_expected.to have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="bar.gif"][@href="bar.gif"][@media-type="image/gif"]') }
  end

  context 'when the book has chapters' do
    let(:chapter) { double('chapter', :filename => 'chapter.html', :xml_id => 'chapter1') }
    before do
      allow(book).to receive(:chapters).and_return([chapter])
    end

    it { is_expected.to have_xpath('/xmlns:package/xmlns:manifest/xmlns:item[@id="chapter1"][@href="chapter.html"][@media-type="application/xhtml+xml"]') }
    it { is_expected.to have_xpath('/xmlns:package/xmlns:spine[@toc="ncx"]/xmlns:itemref[@idref="chapter1"]') }
  end
end
