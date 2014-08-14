describe Rpub::Chapter do
  let(:subject) { described_class.new('foo', 1, 'document') }

  describe '#content' do
    subject { super().content }
    it { is_expected.to eq('foo') }
  end

  describe '#number' do
    subject { super().number }
    it { is_expected.to eq(1) }
  end

  describe '#layout' do
    subject { super().layout }
    it { is_expected.to eq('document') }
  end

  describe '#uid' do
    it 'should change when content changes' do
      expect(subject.uid).to_not eql(described_class.new('bar', 1, 'bar').uid)
    end

    it 'should change when layout changes' do
      expect(subject.uid).to_not eql(described_class.new('foo', 1, 'qux').uid)
    end

    it 'should change when content changes' do
      expect(subject.uid).to_not eql(described_class.new('foo', 2, 'bar').uid)
    end
  end

  describe '#xml_id' do
    describe '#xml_id' do
      subject { super().xml_id }
      it { is_expected.to eq('chapter-1') }
    end
  end

  describe '#filename' do
    describe '#filename' do
      subject { super().filename }
      it { is_expected.to eq('chapter-1-untitled.html') }
    end
  end

  describe '#outline' do
    context 'when there are no headings' do
      let(:subject) { described_class.new('foo', 1, 'document') }

      describe '#outline' do
        subject { super().outline }

        it 'has no elements' do
          expect(subject.size).to eq(0)
        end
      end

      describe '#outline' do
        subject { super().outline }
        it { is_expected.to be_empty }
      end
    end

    context 'when there are headings' do
      let(:subject) { described_class.new('# foo', 1, 'document') }

      describe '#outline' do
        subject { super().outline }

        it 'has 1 element' do
          expect(subject.size).to eq(1)
        end
      end

      context 'a single heading entry' do
        let(:subject) { described_class.new('# foo', 1, 'document').outline.first }

        describe '#level' do
          subject { super().level }
          it { is_expected.to eq(1) }
        end

        describe '#text' do
          subject { super().text }
          it { is_expected.to eq('foo') }
        end

        describe '#html_id' do
          subject { super().html_id }
          it { is_expected.to eq('foo') }
        end
      end
    end
  end

  describe '#title' do
    context 'without a suitable markdown title' do
      describe '#title' do
        subject { super().title }
        it { is_expected.to eq('untitled') }
      end
    end

    context 'with a markdown heading' do
      let(:subject) { described_class.new('# My Title', 1, 'bar') }

      describe '#title' do
        subject { super().title }
        it { is_expected.to eq('My Title') }
      end
    end
  end

  describe 'markdown parsing' do
    let(:subject) { described_class.new('foo', 1, nil) }

    describe '#to_html' do
      subject { super().to_html }
      it { is_expected.to eq("<p>foo</p>\n") }
    end
  end

  describe '#images' do
    let(:subject) { described_class.new('![alt](foo.png)', 1, 'document') }

    it 'has 1 image' do
      expect(subject.images.size).to eq(1)
    end

    describe '#images' do
      subject { super().images }
      describe '#first' do
        subject { super().first }
        it { is_expected.to eq('foo.png') }
      end
    end
  end

  describe '#outline' do
    let(:subject) { described_class.new("# foo\n\nbla bla bla \n\n## bar\n\n# baz", 1, nil) }
    it 'should list headings in order' do
      expect(subject.outline.map(&:text)).to eql(%w[foo bar baz])
    end
  end
end
