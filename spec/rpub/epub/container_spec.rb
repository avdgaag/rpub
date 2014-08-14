describe Rpub::Epub::Container do
  let(:subject) { described_class.new.render }
  it { is_expected.to have_xpath('/xmlns:container') }
  it { is_expected.to have_xpath('/xmlns:container[@version="1.0"]') }
  it { is_expected.to have_xpath('/xmlns:container/xmlns:rootfiles/xmlns:rootfile[@media-type="application/oebps-package+xml"]') }
end
