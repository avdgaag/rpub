require 'simplecov'
SimpleCov.start

require 'rpub'
require 'nokogiri'

FIXTURES_DIRECTORY = File.expand_path('../fixtures', __FILE__)

RSpec::Matchers.define :remove_file do |filename|
  match do |block|
    before = File.exist?(filename)
    block.call
    after = File.exist?(filename)
    before && !after
  end
end

RSpec::Matchers.define :create_file do |*filenames|
  match do |block|
    before = filenames.all?(&File.method(:exist?))
    block.call
    after = filenames.all?(&File.method(:exist?))
    !before && after
  end
end

RSpec::Matchers.define :have_xpath do |xpath, *args|
  match do |xml|
    Nokogiri::XML(xml).xpath(xpath, *args).any?
  end
end
