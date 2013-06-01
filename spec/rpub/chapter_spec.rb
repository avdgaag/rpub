require 'spec_helper'

describe Rpub::Chapter do
  let(:subject) { described_class.new('foo', 1, 'document') }

  its(:content) { should == 'foo' }
  its(:number)  { should == 1 }
  its(:layout)  { should == 'document' }

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
    its(:xml_id) { should == 'chapter-1' }
  end

  describe '#filename' do
    its(:filename) { should == 'chapter-1-untitled.html' }
  end

  describe '#outline' do
    context 'when there are no headings' do
      let(:subject) { described_class.new('foo', 1, 'document') }
      its(:outline) { should have(0).elements }
      its(:outline) { should be_empty }
    end

    context 'when there are headings' do
      let(:subject) { described_class.new('# foo', 1, 'document') }
      its(:outline) { should have(1).elements }

      context 'a single heading entry' do
        let(:subject) { described_class.new('# foo', 1, 'document').outline.first }
        its(:level)   { should == 1 }
        its(:text)    { should == 'foo' }
        its(:html_id) { should == 'foo' }
      end
    end
  end

  describe '#title' do
    context 'without a suitable markdown title' do
      its(:title) { should == 'untitled' }
    end

    context 'with a markdown heading' do
      let(:subject) { described_class.new('# My Title', 1, 'bar') }
      its(:title) { should == 'My Title' }
    end
  end

  describe 'markdown parsing' do
    let(:subject) { described_class.new('foo', 1, nil) }
    its(:to_html) { should == "<p>foo</p>\n" }
  end

  describe '#images' do
    let(:subject) { described_class.new('![alt](foo.png)', 1, 'document') }

    it { should have(1).images }
    its('images.first') { should == 'foo.png' }
  end

  describe '#outline' do
    let(:subject) { described_class.new("# foo\n\nbla bla bla \n\n## bar\n\n# baz", 1, nil) }
    it 'should list headings in order' do
      expect(subject.outline.map(&:text)).to eql(%w[foo bar baz])
    end
  end
end
