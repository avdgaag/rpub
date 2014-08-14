describe Rpub::Book do
  let(:context) { Rpub::Context.new }
  let(:subject) { described_class.new(context) }
  before        { allow(context).to receive(:chapter_files).and_return(['foo']) }
  it            { is_expected.to respond_to(:config) }

  describe 'chapters' do
    it 'has 1 chapter' do
      expect(subject.chapters.size).to eq(1)
    end

    it { is_expected.to be_kind_of(Enumerable) }

    it 'should start with context chapters' do
      expect(subject.chapters.size).to eq(1)
    end

    it 'should allow chaining multiple calls' do
      subject << 'foo' << 'bar'
      expect(subject.chapters.size).to eq(3)
    end

    it 'should yield chapters' do
      yielded = false
      subject.each { |c| yielded = true }
      expect(yielded).to be_truthy
    end
  end

  describe '#has_fonts?' do
    it 'should not have a font by default' do
      expect(context).to receive(:fonts).and_return([])
      is_expected.not_to have_fonts
    end

    it 'should have a font with a non-empty array' do
      expect(context).to receive(:fonts).and_return(['foo'])
      is_expected.to have_fonts
    end
  end

  describe '#uid' do
    it 'should change when chapters change' do
      expect(described_class.new(context).add_chapter('foo')).to_not eql(subject.uid)
    end

    it 'should change when config changes' do
      expect(described_class.new(context)).to_not eql(subject.uid)
    end
  end

  describe '#outline' do
    before { expect(context).to receive(:chapter_files).and_return([]) }

    it 'should return empty array when there are no chapters' do
      expect(subject.outline).to be_empty
    end

    it 'should return combination of all chapter outlines with filename' do
      subject << '# foo' << '# bar'
      expect(subject.outline.size).to eq(2)
    end

    it 'should combine chapter outlines' do
      subject << '# foo' << '# bar'
      expect(subject.outline.first[0]).to eql('chapter-0-foo.html')
      expect(subject.outline.first[1][0].text).to eql('foo')
    end
  end

  describe '#has_cover?' do
    it 'should not have a cover without a config key' do
      is_expected.not_to have_cover
    end

    it 'should not have a cover with a config key that is false' do
      expect(context).to receive(:config).and_return(OpenStruct.new({ 'cover_image' => false }))
      is_expected.not_to have_cover
    end

    it 'should have a cover with a config key' do
      expect(context).to receive(:config).and_return(OpenStruct.new({ 'cover_image' => true }))
      is_expected.to have_cover
    end
  end

  describe '#has_toc?' do
    it 'should not have a toc without a config key' do
      expect(context).to receive(:config).and_return(OpenStruct.new)
      is_expected.not_to have_toc
    end

    it 'should not have a toc with a config key that is false' do
      expect(context).to receive(:config).and_return(OpenStruct.new({ 'toc' => false }))
      is_expected.not_to have_toc
    end

    it 'should have a toc with a config key' do
      expect(context).to receive(:config).and_return(OpenStruct.new({ 'toc' => true }))
      is_expected.to have_toc
    end
  end

  describe '#images' do
    before { subject << '![foo](bar)' << '![baz](qux)' << '![bla](qux)' }

    it 'has 2 images' do
      expect(subject.images.size).to eq(2)
    end

    it 'has includes each unique image' do
      expect(subject.images).to include('bar', 'qux')
    end
  end
end
