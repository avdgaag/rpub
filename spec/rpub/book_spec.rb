require 'spec_helper'

describe Rpub::Book do
  let(:context) { Rpub::Context.new }
  let(:subject) { described_class.new(context) }
  before        { context.stub! :chapter_files => ['foo'] }
  it            { should respond_to(:config) }

  describe 'chapters' do
    it { should have(1).chapters }

    it { should be_kind_of(Enumerable) }

    it 'should start with context chapters' do
      should have(1).chapters
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
      context.should_receive(:fonts).and_return([])
      should_not have_fonts
    end

    it 'should have a font with a non-empty array' do
      context.should_receive(:fonts).and_return(['foo'])
      should have_fonts
    end
  end

  describe '#uid' do
    it 'should change when chapters change' do
      described_class.new(context).add_chapter('foo').should_not == subject.uid
    end

    it 'should change when config changes' do
      described_class.new(context).should_not == subject.uid
    end
  end

  describe '#outline' do
    before { context.should_receive(:chapter_files).and_return([]) }

    it 'should return empty array when there are no chapters' do
      subject.outline.should be_empty
    end

    it 'should return combination of all chapter outlines with filename' do
      subject << '# foo' << '# bar'
      subject.outline.should have(2).elements
    end

    it 'should combine chapter outlines' do
      subject << '# foo' << '# bar'
      subject.outline.first[0].should == 'chapter-0-foo.html'
      subject.outline.first[1][0].text.should == 'foo'
    end
  end

  describe '#has_cover?' do
    it 'should not have a cover without a config key' do
      should_not have_cover
    end

    it 'should not have a cover with a config key that is false' do
      context.should_receive(:config).and_return(OpenStruct.new({ 'cover_image' => false }))
      should_not have_cover
    end

    it 'should have a cover with a config key' do
      context.should_receive(:config).and_return(OpenStruct.new({ 'cover_image' => true }))
      should have_cover
    end
  end

  describe '#has_toc?' do
    it 'should not have a toc without a config key' do
      context.should_receive(:config).and_return(OpenStruct.new)
      should_not have_toc
    end

    it 'should not have a toc with a config key that is false' do
      context.should_receive(:config).and_return(OpenStruct.new({ 'toc' => false }))
      should_not have_toc
    end

    it 'should have a toc with a config key' do
      context.should_receive(:config).and_return(OpenStruct.new({ 'toc' => true }))
      should have_toc
    end
  end

  describe '#images' do
    before       { subject << '![foo](bar)' << '![baz](qux)' << '![bla](qux)' }
    it           { should have(2).images }
    its(:images) { should include('bar') }
    its(:images) { should include('qux') }
  end
end
