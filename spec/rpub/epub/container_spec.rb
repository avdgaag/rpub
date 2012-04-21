require 'spec_helper'

describe Rpub::Epub::Container do
  let(:subject) { described_class.new.render }
  it { should have_xpath('/xmlns:container') }
  it { should have_xpath('/xmlns:container[@version="1.0"]') }
  it { should have_xpath('/xmlns:container/xmlns:rootfiles/xmlns:rootfile[@media-type="application/oebps-package+xml"]') }
end
