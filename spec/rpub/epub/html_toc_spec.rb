describe Rpub::Epub::HtmlToc do
  let(:outline) { [] }
  let(:book)    { double('book', :outline => outline, :config => config) }
  let(:config)  { OpenStruct.new({ 'max_level' => 1 }) }
  let(:subject) { described_class.new(book).render }

  it { is_expected.to have_xpath('/div/h1[text()="Table of Contents"]') }
  it { is_expected.to have_xpath('/div/div[@class="toc"]') }

  context 'without headings in the outline' do
    it { is_expected.not_to have_xpath('//a') }
  end

  context 'with heading in the outline' do
    let(:outline) { [['foo.html', [double('heading 1', :text => 'link 1', :html_id => 'bar', :level => 1), double('heading 2', :text => 'link 2', :html_id => 'bar', :level => 2)]]] }
    it { is_expected.to have_xpath('/div/div/div[@class="level-1"]/a[@href="foo.html#bar"][text()="link 1"]') }
    it { is_expected.not_to have_xpath('/div/div/div[@class="level-1"]/a[@href="foo.html#bar"][text()="link 2"]') }
  end
end
