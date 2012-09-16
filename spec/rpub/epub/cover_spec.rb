require 'spec_helper'

describe Rpub::Epub::Cover do
  let(:book)    { double('book', config: double('config', :cover_image => 'cover.jpg', :title => 'title')) }
  let(:subject) { described_class.new(book).render }

  it { should have_xpath('/xmlns:html/xmlns:head/xmlns:title[text()="Cover"]') }
  it { should have_xpath('/xmlns:html/xmlns:body/xmlns:div/xmlns:img[@src="cover.jpg"][@alt="title"]') }
end
