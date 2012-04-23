require 'spec_helper'

describe Rpub::Book do
  let(:subject) { described_class.new('some_file', 'title' => 'My "Awesome" Title!', 'version' => '1.0.3') }

  it 'should start with an empty configuration' do
    described_class.new('some_file').config.should == {}
  end

  it             { should respond_to(:title) }
  its(:title)    { should == 'My "Awesome" Title!' }
  its(:filename) { should == 'my-awesome-title-1.0.3.epub' }

  describe 'chapters' do
    before { subject.add_chapter 'foo' }

    it { should have(1).chapters }

    it { should be_kind_of(Enumerable) }

    it 'should start with no chapters' do
      described_class.new('foo').should have(0).chapters
    end

    it 'should allow chaining multiple calls' do
      subject << 'foo' << 'bar'
      subject.should have(3).chapters
    end

    it 'should yield chapters' do
      yielded = false
      subject.each { |c| yielded = true }
      yielded.should be_true
    end
  end

  describe '#has_fonts?' do
    it 'should not have a font by default' do
      described_class.new(nil, {}).should_not have_fonts
    end

    it 'should not have a font with an empty array' do
      described_class.new(nil, nil, []).should_not have_fonts
    end

    it 'should have a font with a non-empty array' do
      described_class.new(nil, nil, ['foo']).should have_fonts
    end
  end

  describe '#uid' do
    it 'should change when chapters change' do
      Rpub::Book.new('bar').add_chapter('foo').should_not == subject.uid
    end

    it 'should change when config changes' do
      Rpub::Book.new('bar', 'baz' => 'qux').should_not == subject.uid
    end
  end

  describe '#outline' do
    it 'should return empty array when there are no chapters' do
      subject.outline.should be_empty
    end

    it 'should return combination of all chapter outlines with filename' do
      subject << '# foo' << '# bar'
      subject.outline.should have(2).elements
    end
  end

  describe '#has_cover?' do
    it 'should not have a cover without a config key' do
      described_class.new(nil, {}).should_not have_cover
    end

    it 'should not have a cover with a config key that is false' do
      described_class.new(nil, { 'cover_image' => false }).should_not have_cover
    end

    it 'should have a cover with a config key' do
      described_class.new(nil, { 'cover_image' => true}).should have_cover
    end
  end

  describe '#has_toc?' do
    it 'should not have a toc without a config key' do
      described_class.new(nil, {}).should_not have_toc
    end

    it 'should not have a toc with a config key that is false' do
      described_class.new(nil, { 'toc' => false }).should_not have_toc
    end

    it 'should have a toc with a config key' do
      described_class.new(nil, { 'toc' => true }).should have_toc
    end
  end

  describe '#images' do
    before { subject << '![foo](bar)' << '![baz](qux)' << '![bla](qux)' }
    it { should have(2).images }
    its(:images) { should include('bar') }
    its(:images) { should include('qux') }
  end

  describe '#outline' do
    before { subject << '# foo' << '## bar' }
    its(:outline) { should have(2).elements }
    it 'should combine chapter outlines' do
      subject.outline.first[0].should == 'chapter-0-foo.html'
      subject.outline.first[1][0].text.should == 'foo'
    end
  end
end
